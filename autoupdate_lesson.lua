script_name('Auto Login script') -- �������� �������
script_author('Kit lapka') -- ����� �������
script_description('Autoupdate') -- �������� �������

require "lib.moonloader" -- ����������� ����������
local dlstatus = require('moonloader').download_status
local inicfg = require 'inicfg'
local keys = require "vkeys"
local imgui = require 'imgui'
local encoding = require 'encoding'
local tag = "{0777A3}[Kit Lapka]: {CCCCCC}"
encoding.default = 'CP1251'
u8 = encoding.UTF8

update_state = false

local script_vers = 2
local script_vers_text = "1.05"

local update_url = "https://raw.githubusercontent.com/Daria2006/script/main/update.ini" -- ��� ���� ���� ������
local update_path = getWorkingDirectory() .. "/update.ini" -- � ��� ���� ������

local script_url = "https://github.com/thechampguess/scripts/blob/master/autoupdate_lesson_16.luac?raw=true" -- ��� ���� ������
local script_path = thisScript().path


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
    sampRegisterChatCommand("test", cmd_update)
	
	sampAddChatMessage(tag .. '������� ��������.')

	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
    nick = sampGetPlayerNickname(id)

    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then
                sampAddChatMessage("���� ����������! ������: " .. updateIni.info.vers_text, -1)
                update_state = true
            end
            os.remove(update_path)
        end
    end)
    
	while true do
        wait(0)

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    sampAddChatMessage("������ ������� ��������!", -1)
                    thisScript():reload()
                end
            end)
            break
        end

	end
end

function cmd_update()
    sampAddChatMessage("�������������� v2.0 ����{FFFFFF}��� ���� �� ����������{FFF000}����� ������")
end
