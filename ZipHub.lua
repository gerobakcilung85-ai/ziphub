-- ExtremeSecurityTest.client.lua
-- Letakkan di:
-- StarterPlayer > StarterPlayerScripts
--
-- HANYA untuk Roblox Studio / private test server.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	return
end

local player = Players.LocalPlayer

-- =========================
-- CONFIG
-- =========================

local LASER_COUNT = 10_000
local LIGHT_COUNT = 200_000

-- FireServer test dibatasi supaya tidak menjadi DoS.
local REMOTE_COUNT = 10_000
local REMOTE_BATCH = 100
local REMOTE_DELAY = 0.05

-- Watchdog
local MAX_RUNTIME = 30
local MAX_HEARTBEAT_DELAY = 0.25

-- =========================
-- REMOTE
-- =========================

local testFolder = ReplicatedStorage:FindFirstChild("SecurityTest")

if not testFolder then
	warn("[SecurityTest] SecurityTest folder tidak ditemukan.")
	return
end

local stressRemote = testFolder:FindFirstChild("StressTestRemote")

if not stressRemote then
	warn("[SecurityTest] StressTestRemote tidak ditemukan.")
	return
end

-- =========================
-- STATE
-- =========================

local running = false
local startTime = 0

local stats = {
	laser = 0,
	light = 0,
	remote = 0,
}

-- =========================
-- WATCHDOG
-- =========================

local function watchdog()
	if not running then
		return false
	end

	if os.clock() - startTime >= MAX_RUNTIME then
		warn("[SecurityTest] STOP: maximum runtime reached.")
		return false
	end

	return true
end

-- =========================
-- LASER SIMULATION
-- =========================

local function simulateLasers()

	print("[SecurityTest] Laser test:", LASER_COUNT)

	local accumulator = 0

	for i = 1, LASER_COUNT do

		if not watchdog() then
			return false
		end

		local origin = Vector3.new(
			math.sin(i * 0.01),
			math.cos(i * 0.02),
			i % 250
		)

		local direction = Vector3.new(
			math.cos(i * 0.03),
			math.sin(i * 0.04),
			math.cos(i * 0.05)
		)

		accumulator += origin:Dot(direction)

		stats.laser += 1

		if i % 500 == 0 then
			RunService.Heartbeat:Wait()
		end
	end

	print(
		"[SecurityTest] Laser complete:",
		stats.laser,
		"checksum:",
		accumulator
	)

	return true
end

-- =========================
-- LIGHT SIMULATION
-- =========================

local function simulateLights()

	print("[SecurityTest] Light test:", LIGHT_COUNT)

	local accumulator = 0

	for i = 1, LIGHT_COUNT do

		if not watchdog() then
			return false
		end

		-- Simulasi perhitungan cahaya.
		-- Tidak membuat Instance Light sungguhan.

		local brightness =
			math.abs(math.sin(i * 0.001))

		local range =
			8 + math.abs(math.cos(i * 0.002)) * 32

		local attenuation =
			1 / (1 + range * 0.01)

		accumulator +=
			brightness *
			range *
			attenuation

		stats.light += 1

		if i % 2_000 == 0 then
			RunService.Heartbeat:Wait()
		end
	end

	print(
		"[SecurityTest] Light complete:",
		stats.light,
		"checksum:",
		accumulator
	)

	return true
end

-- =========================
-- REMOTE FLOOD TEST
-- =========================

local function testRemote()

	print("[SecurityTest] RemoteEvent test:", REMOTE_COUNT)

	for i = 1, REMOTE_COUNT do

		if not watchdog() then
			return false
		end

		-- Request normal ke server.
		-- Server harus memiliki rate limiter.

		stressRemote:FireServer(
			"SecurityStressTest",
			i
		)

		stats.remote += 1

		if i % REMOTE_BATCH == 0 then
			task.wait(REMOTE_DELAY)
		end
	end

	print(
		"[SecurityTest] Remote test complete:",
		stats.remote
	)

	return true
end

-- =========================
-- MAIN
-- =========================

local function runTest()

	if running then
		return
	end

	running = true
	startTime = os.clock()

	stats.laser = 0
	stats.light = 0
	stats.remote = 0

	print("================================")
	print(" EXTREME SECURITY STRESS TEST")
	print("================================")

	local success = true

	success = simulateLasers()

	if success then
		success = simulateLights()
	end

	if success then
		success = testRemote()
	end

	running = false

	local elapsed = os.clock() - startTime

	print("================================")
	print(" SECURITY TEST FINISHED")
	print("================================")

	print("Laser:", stats.laser, "/", LASER_COUNT)
	print("Light:", stats.light, "/", LIGHT_COUNT)
	print("Remote:", stats.remote, "/", REMOTE_COUNT)
	print("Runtime:", elapsed)

	if success then
		print("[SecurityTest] RESULT: COMPLETED")
	else
		warn("[SecurityTest] RESULT: STOPPED BY WATCHDOG")
	end
end

task.wait(3)

runTest()
