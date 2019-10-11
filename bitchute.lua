--[[
	Bitchute VLC plugin v1.0.0
	https://github.com/caresx/vlc-bitchute
	MIT license
--]]


-- Probe function.
function probe()
	return (vlc.access == "http" or vlc.access == "https")
		and (string.match(vlc.path, "bitchute%.com/video/"))
end

-- Parse function.
function parse()
	if string.match(vlc.path, "bitchute%.com/video/") then
		return parse_video_page()
	end

	vlc.msg.err("Failed to extract a video URL")
	return {}
end

function parse_video_page()
	local line
	while true do
		line = vlc.readline()
		if line == nil then
			break
		end

		if string.match(line, "<source src=\"") then
			local video_url = string.match(line, "https://.+%.mp4")
			return { { path = video_url } }
		end
	end

	vlc.msg.err("Failed to extract a video URL")
	return {}
end
