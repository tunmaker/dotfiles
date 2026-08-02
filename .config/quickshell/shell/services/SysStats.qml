pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// System statistics from /proc and /sys. Pure file reads on a timer; the only
// subprocess is a one-shot probe to locate the CPU temperature sensor, because
// hwmon numbering is not stable across boots.
Singleton {
    id: root

    readonly property real cpuPercent: _cpu
    readonly property real memPercent: _mem
    readonly property int tempC: _temp
    readonly property real rxRate: _rx   // bytes/s
    readonly property real txRate: _tx
    readonly property bool tempAvailable: _tempPath !== ""

    property real _cpu: 0
    property real _mem: 0
    property int _temp: 0
    property real _rx: 0
    property real _tx: 0
    property string _tempPath: ""

    property var _last: ({ busy: 0, total: 0, rx: 0, tx: 0, stamp: 0 })

    function fmtRate(bytesPerSec: real): string {
        if (bytesPerSec >= 1048576)
            return `${(bytesPerSec / 1048576).toFixed(1)}M`;
        if (bytesPerSec >= 1024)
            return `${Math.round(bytesPerSec / 1024)}k`;
        return `${Math.round(bytesPerSec)}B`;
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            statFile.reload();
            memFile.reload();
            netFile.reload();
            if (root._tempPath !== "")
                tempFile.reload();
        }
    }

    FileView {
        id: statFile

        path: "/proc/stat"

        onLoaded: {
            const fields = text().split("\n")[0].trim().split(/\s+/).slice(1).map(Number);
            const idle = fields[3] + fields[4];
            const total = fields.reduce((sum, value) => sum + value, 0);
            const busy = total - idle;

            const last = root._last;
            if (last.total > 0 && total > last.total)
                root._cpu = (busy - last.busy) / (total - last.total) * 100;
            last.busy = busy;
            last.total = total;
        }
    }

    FileView {
        id: memFile

        path: "/proc/meminfo"

        onLoaded: {
            const content = text();
            const total = Number(content.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0);
            const avail = Number(content.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0);
            if (total > 0)
                root._mem = (1 - avail / total) * 100;
        }
    }

    FileView {
        id: netFile

        path: "/proc/net/dev"

        onLoaded: {
            let rx = 0;
            let tx = 0;
            for (const line of text().split("\n").slice(2)) {
                const at = line.indexOf(":");
                if (at < 0)
                    continue;
                const name = line.slice(0, at).trim();
                // Physical interfaces only; virtual ones (docker bridges,
                // veths, tunnels) would double-count the same traffic.
                if (name === "lo" || name.startsWith("veth") || name.startsWith("br-") || name.startsWith("docker") || name.startsWith("tun") || name.startsWith("tailscale") || name.startsWith("virbr"))
                    continue;
                const fields = line.slice(at + 1).trim().split(/\s+/).map(Number);
                rx += fields[0];
                tx += fields[8];
            }

            const now = Date.now();
            const last = root._last;
            const dt = (now - last.stamp) / 1000;
            if (last.stamp > 0 && dt > 0.2 && rx >= last.rx) {
                root._rx = (rx - last.rx) / dt;
                root._tx = (tx - last.tx) / dt;
            }
            last.rx = rx;
            last.tx = tx;
            last.stamp = now;
        }
    }

    FileView {
        id: tempFile

        path: root._tempPath

        onLoaded: {
            const value = parseInt(text().trim());
            if (!isNaN(value))
                root._temp = Math.round(value / 1000);
        }
    }

    // One-shot: find the CPU die sensor by driver name. k10temp is AMD;
    // the fallbacks cover Intel and the zenpower driver.
    Process {
        id: sensorProbe

        command: ["grep", "-sH", "", "/sys/class/hwmon/hwmon0/name", "/sys/class/hwmon/hwmon1/name", "/sys/class/hwmon/hwmon2/name", "/sys/class/hwmon/hwmon3/name", "/sys/class/hwmon/hwmon4/name", "/sys/class/hwmon/hwmon5/name", "/sys/class/hwmon/hwmon6/name", "/sys/class/hwmon/hwmon7/name", "/sys/class/hwmon/hwmon8/name", "/sys/class/hwmon/hwmon9/name"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                const entries = text.trim().split("\n").map(line => {
                    const at = line.indexOf(":");
                    return { path: line.slice(0, at), name: line.slice(at + 1).trim() };
                });

                for (const wanted of ["k10temp", "zenpower", "coretemp"]) {
                    const hit = entries.find(entry => entry.name === wanted);
                    if (hit) {
                        root._tempPath = hit.path.replace("/name", "/temp1_input");
                        return;
                    }
                }
            }
        }
    }
}
