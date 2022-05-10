# OTS-Camera-Roblox

## Installing to Roblox
Repo contains all source files, which are imported to Roblox using Rojo.

If you do not use Rojo, you can use provided **OTS-Camera.rbxm** file [here](https://github.com/MonzterDev/OTS-Camera-Roblox/blob/main/OTS-Camera.rbxm) or the [direct download](https://github.com/MonzterDev/OTS-Camera-Roblox/raw/main/OTS-Camera.rbxm).

## Using the Module
1. Add Module to **StarterPlayerScripts**
2. Create a **LocalScript** with the following contents:
```LUA
local Players = game:GetService('Players')

local Player = Players.LocalPlayer
local PlayerScripts = Player.PlayerScripts

local OTS_Camera = require(PlayerScripts:WaitForChild("OTS-Camera"))
OTS_Camera:Enable()
```
3. You may need to change `require(PlayerScripts:WaitForChild("OTS-Camera"))` to point to wherever you put the Module

## Credit
https://devforum.roblox.com/t/over-the-shoulder-camera-system/728481/121?u=m_nzter
