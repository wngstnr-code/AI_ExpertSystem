"""
Runner script untuk menjalankan program CLIPS (.clp) menggunakan clipspy.
Menggunakan custom router agar I/O CLIPS berjalan interaktif di terminal.
"""
import clips
import sys


class InteractiveRouter(clips.Router):
    """Custom CLIPS router agar read/printout berjalan lewat stdin/stdout."""

    def __init__(self):
        super().__init__("python-io", priority=40)

    def query(self, name):
        return name in ("stdout", "stdin")

    def write(self, name, message):
        sys.stdout.write(message)
        sys.stdout.flush()

    def read(self, name):
        ch = sys.stdin.read(1)
        return ord(ch) if ch else -1

    def unread(self, name, ch):
        return ch

    def exit(self, code):
        pass


env = clips.Environment()

# Daftarkan router interaktif
router = InteractiveRouter()
env.add_router(router)

env.load("rekomendasi_laptop.clp")
env.reset()
env.run()
