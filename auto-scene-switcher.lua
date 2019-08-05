
obs = obslua
running = false
math.randomseed(os.time())
interval_in_seconds = 5

-- called on startup
function script_load(settings)
    print("Loaded Auto Scene Switcher")
end

function list_scenes()
    local scenes = obs.obs_frontend_get_scenes()
    print("SCENES:")
    for i, source in pairs(scenes) do
        source_name = obs.obs_source_get_name(source)
        print(source_name)
    end
    obs.source_list_release(scenes)
end

function toggle_button_clicked(props, button)
    
    if running then
        print("Stopping")
        obs.timer_remove(switch)
        running = false
    else
        print("Starting")
        print(interval_in_seconds)
        timer = obs.timer_add(switch, interval_in_seconds * 1000)
        list_scenes()
        running = true
        switch()
    end
    
    return false
end

function script_update(settings)
    interval_in_seconds = obs.obs_data_get_int(settings, "interval_in_seconds")
    print(interval_in_seconds)
end

function switch()
    local scenes = obs.obs_frontend_get_scenes()
    local random_index = math.random(1, table.getn(scenes))
    local selected_scene = scenes[random_index]
    print("---selecting---")
    print(obs.obs_source_get_name(selected_scene))
    obs.obs_frontend_set_current_scene(selected_scene)
    obs.source_list_release(scenes)
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_button(props, "toggle_button", "Toggle", toggle_button_clicked )
    obs.obs_properties_add_int(props, "interval_in_seconds", "Switch Interval (s)", 1, 3600, 1)
    return props
end

function script_defaults(settings)
    obs.obs_data_set_default_int(settings, "interval_in_seconds", interval_in_seconds)
end
