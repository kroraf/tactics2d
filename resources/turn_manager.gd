extends Resource
class_name TurnManager

enum {PLAYER_TURN, ENEMY_TURN}

signal ally_turn_started
signal enemy_turn_started

var turn:
	set(value):
		turn = value
		match turn:
			PLAYER_TURN: ally_turn_started.emit()
			ENEMY_TURN: enemy_turn_started.emit()
