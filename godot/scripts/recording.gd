extends Pickup
class_name record

@export var audio_file: AudioStream
@export var recording_name: String
@export var artist: String
@export var type: recording_types

enum recording_types {RECORD, CASSETTE}
