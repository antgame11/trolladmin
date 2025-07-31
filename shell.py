import asyncio
import websockets
import time
connected_clients = set()

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

async def main():
    server = await websockets.serve(handler, "localhost", 8765)
    print("WebSocket server listening on ws://localhost:8765")

    await asyncio.gather(
        server.wait_closed(),
        send_console_input()
    )

if __name__ == "__main__":
    asyncio.run(main())
