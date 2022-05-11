import "dome" for Window
import "random" for Random
import "input" for Keyboard, Mouse
import "graphics" for Canvas, Color

class Collisions {
  // Implements
  // https://developer.mozilla.org/en-US/docs/Games/Techniques/2D_collision_detection
    static touch(hitbox, hitbox2) {
    var hb1x = hitbox["x"]
    var hb1y = hitbox["y"]
    var hb1w = hitbox["width"]
    var hb1h = hitbox["height"]
    var hb2x = hitbox2["x"]
    var hb2y = hitbox2["y"]
    var hb2h = hitbox2["height"]
    var hb2w = hitbox2["width"]
    return (hb1x < hb2x + hb2w &&
            hb1x + hb1w > hb2x &&
            hb1y < hb2y + hb2h &&
            hb1y + hb1h > hb2y)
    }
    static collide(hitbox, hitbox2) {
    return (hitbox.x < hitbox2.x + hitbox2.width &&
            hitbox.x + hitbox.width > hitbox2.x &&
            hitbox.y < hitbox2.y + hitbox2.height &&
            hitbox.y + hitbox.height > hitbox2.y)
    }
    static p2e_collide(hb2x, hb2y){
        return (Mouse.x < hb2x + 10 &&
            Mouse.x + 10 > hb2x &&
            Mouse.y < hb2y + 10 &&
            Mouse.y + 10 > hb2y)
    }
}

class Enemy {
  x {_x}
  y {_y}
  gotox {_gtx}
  gotoy {_gty}
  speed {_spd}
  width {10}
  height {10}
  random {_rand}
  construct new(){
    _rand = Random.new()
    _gtx = 0
    _gty = 0
    _spd = 0
    _x = random.int(240)
    _y = random.int(136)
  }
  update() {
    if (speed == 0){
      _gtx = random.int(240)
      _gty = random.int(136)
      _spd = 1
    } else {
      if (x != gotox) {
        if (x > gotox) {
          _x = x - 1
        } else {
          _x = x + 1
        }
      }
      if (y != gotoy) {
        if (y > gotoy) {
          _y = y - 1
        } else {
          _y = y + 1
        }
      }
    }
    if (speed == 1 && gotox == x && gotoy == y){
      _spd = 0
    }
  }
  draw() {
    Canvas.rectfill(x, y, width, height, Color.darkpurple)
  }
}

class Bullet {
  x {_x}
  y {_y}
  width {5}
  height {5}
  player {_player}
  tick {_tick}
  tick = (value) {_tick = value}
  x = (value) {_x = value}
  y = (value) {_y = value}
  construct new(player) {
    _player = player
    _x = Mouse.x
    _y = Mouse.y
    _tick = 0
  }
  update() {
    _tick = tick +1
  }
  draw() {
    if (tick >= 60 * 0.01) {
      tick = 0
      _y = y - 2
    }
    //Canvas.pset(x, y, Color.yellow)
    Canvas.rectfill(x-2.5, y-2.5 , 5, 5, Color.yellow)
  }
}

class EnemyBullet {
  xlst {_xlst}
  ylst {_ylst}
  width {5}
  height {5}
  enemy {_enemy}
  tick {_tick}
  tick = (value) {_tick = value}
  xlst = (value) {_xlst = value}
  ylst = (value) {_ylst = value}
  construct new(en) {
    _enemy = en
    _xlst = [enemy.x, enemy.x, enemy.x]
    _ylst = [enemy.y, enemy.y, enemy.y]
    _tick = 0
  }
  update() {
    _tick = tick +1
  }
  draw() {
    if (tick >= 60 * 0.01) {
      tick = 0
      _xlst = [xlst[0], xlst[1]+1, xlst[2]-1]
      _ylst = [ylst[0]+2, ylst[1]+2, ylst[2]+2]
    }
    Canvas.rectfill(xlst[0], ylst[0] , 5, 5, Color.red)
    Canvas.rectfill(xlst[1], ylst[1] , 5, 5, Color.red)
    Canvas.rectfill(xlst[2], ylst[2] , 5, 5, Color.red)
  }
}

class Player {
  x {_x}
  y {_y}
  width {_w}
  height {_h}
  construct new() {
    _w = 10
    _h = 10
  }
  update() {
    _x = Mouse.x
    _y = Mouse.y    
  }
  draw() {
    // Canvas.pset(Mouse.x, Mouse.y, Color.blue)
    Canvas.rectfill(x, y, width, height, Color.blue)
  }
}

class main {
  construct new() {}
  init() {
    _ENEMY_HEALTH_ = 100
    _collide = false
    Mouse.hidden = true
    _ticks = 0
    _bullets = []
    _rand = Random.new()
    _scale = 4
    _enemy = Enemy.new()
    _player = Player.new()
    Canvas.resize(240, 136)
    Window.resize(_scale * Canvas.width, _scale * Canvas.height)
    Window.title = "Dome"
  }
  update() {
    _collide = Collisions.p2e_collide(_enemy.x, _enemy.y)
    _ticks = _ticks+1
    _bullets.each {|bullet|
      if (Collisions.touch({"x": bullet.x, "y": bullet.y, "width":5, "height":5}, {"x": _enemy.x, "y": _enemy.y, "width": 10, "height": 10})) {
        _ENEMY_HEALTH_ = _ENEMY_HEALTH_ - 1
        bullet.x = 0
        bullet.y = 0
      }
      bullet.update()
    }
    _enemy.update()
    _player.update()
  }
  draw(alpha) {
    Canvas.cls()
    Canvas.print("Enemy: "+_ENEMY_HEALTH_.toString, 1, 1, Color.white)
    // Canvas.pset(_x, _y, Color.blue)
    // if (_ticks >= 60 * 1) {}
    if (_ticks >= 60 * 0.001) {
      if (_ticks >= 60* 0.3) {
        _bullets.add(Bullet.new(Player))
        _ticks = 0
      }
      if (_bullets.count > 0 && _bullets[0].y < 0) {
        _bullets.removeAt(0)
      }
    }
    _bullets.each {|bullet|
      bullet.draw()
    }
    _player.draw()
    _enemy.draw()
  }
}

var Game = main.new()
