local config = {}

-- Размеры окна
config.windowWidth = 1200
config.windowHeight = 800

-- Параметры игры
config.gravity = 400
config.launchForce = 500

-- Изображения
config.images = {
    bird = "assert/images/bird.png",
    pig = "assert/images/bird.png",  -- исправил опечатку
    background = "assert/images/image.png",
    block = "assert/images/block.png",
    menuBackground = "assert/images/menu_background.png",  -- Путь до фона меню
}

-- Звуковые эффекты
config.sounds = {
    levelSwitch = "assert/sounds/level_switch.wav",  -- Путь до звука при переключении уровней
}

return config
