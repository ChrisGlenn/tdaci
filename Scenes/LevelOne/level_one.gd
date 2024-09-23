extends Node2D
# LEVEL ONE SCRIPT
@onready var environment_map : TileMapLayer = get_node("Enviornment_Tiles") # the tilemaps
@onready var visibility_map : TileMapLayer = get_node("Visibility") # the 'fog'
@onready var player = get_node("Player") # the player
const view_distance : int = 12 # defaults to 12
var discovered_tiles : Dictionary = {} # holds the 'discovered' tiles that have been revealed...I believe


func _ready():
    update_fov() # update the field of view

func _process(_delta):
    if Globals.fov_update: 
        # will allow objects to reset field of view
        update_fov() # update the field of view
        Globals.fov_update = false # reset the check


func update_fov():
    # this is taken from 'Godot FOV algorithms-roguelike' from aikoncwd
    # get the player's position in tile map coords
    var player_position = environment_map.local_to_map(player.global_position)
    # set previously discovered tiles back to soft-fog
    for tile in discovered_tiles.keys():
        visibility_map.set_cell(tile, 1, Vector2i(17,24))
    # perform raycasting from the player's position
    raycast_fov(player_position)

func raycast_fov(origin : Vector2):
    # raycast in all directions around the player
    for x in range(-view_distance, view_distance + 1):
        for y in range(-view_distance, view_distance + 1):
            # ignore the origin point
            if x == 0 and y == 0: continue
            # determine the endpoint for this ray
            var end_tile = origin + Vector2(x, y)
            # if the tile is within view range, perform line tracing trowards it
            if end_tile.distance_to(origin) <= view_distance:
                bresenham_line(origin, end_tile)

func bresenham_line(start, end):
    # implementation of Bresenham's line drawing algorithm on a tile map
    var x0 = start.x
    var y0 = start.y
    var x1 = end.x
    var y1 = end.y

    var dx = abs(x1 - x0)
    var dy = abs(y1 - y0)
    var sx = 1 if x0 < x1 else -1
    var sy = 1 if y0 < y1 else -1
    var err = dx - dy

    while true:
        # set the current tile as visible and mark it as discovered
        var tile = Vector2(x0, y0)
        visibility_map.set_cell(tile, -1)
        discovered_tiles[tile] = true

        # if an obstacle is encountered in the line of sight, terminate line tracing
        if environment_map.get_cell_source_id(tile) == 1: return

        # if the endpoint is reached, end the loop
        if x0 == x1 and y0 == y1: break

        # update the current position based on the accumulated error
        var e2 = 2 * err
        if e2 > -dy:
            err -= dy
            x0 += sx
        if e2 < dx:
            err += dx
            y0 += sy


func _on_player_player_moved() -> void:
    update_fov() # update the field of view on player movement
