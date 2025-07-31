# gpted xd

import asyncio
import websockets
import os
import threading
from ahk import AHK
import keyboard

ahk = AHK()

connected_clients = set()
last_window = None
troll_window = None

def focus_terminal():
    global last_window, troll_window
    current = ahk.active_window
    if current and (not troll_window or current != troll_window):
        last_window = current
    if not troll_window:
        troll_window = ahk.find_window(title='Troll Admin')
    if troll_window:
        troll_window.activate()
        ahk.send('!')

def focus_back():
    global last_window
    if last_window:
        last_window.activate()
        ahk.send('!')

def setup_hotkeys():
    keyboard.add_hotkey(';', focus_terminal)

async def handler(websocket):
    connected_clients.add(websocket)
    try:
        async for message in websocket:
            await websocket.send(message)
    except websockets.ConnectionClosed:
        pass
    finally:
        connected_clients.remove(websocket)

async def send_console_input():
    loop = asyncio.get_event_loop()
    while True:
        message = await loop.run_in_executor(None, input, "$ ")
        if connected_clients:
            await asyncio.gather(*(client.send(message) for client in connected_clients))
        focus_back()

async def main():
    os.system("cls")
    os.system("title Troll Admin")
    print("Troll Admin Loaded")

    threading.Thread(target=setup_hotkeys, daemon=True).start()

    server = await websockets.serve(handler, "localhost", 8765)
    print("listening on ws://localhost:8765")

    await asyncio.gather(
        server.wait_closed(),
        send_console_input()
    )

if __name__ == "__main__":
    asyncio.run(main())
