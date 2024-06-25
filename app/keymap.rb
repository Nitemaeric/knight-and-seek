# class Keymap
#   attr_accessor :name

#   DIRECTIONAL_MAPPING = {
#     [true, true] => 0,
#     [true, false] => -1,
#     [false, true] => 1,
#     [false, false] => 0,
#   }

#   def self.all
#     @all ||= [
#       KeyboardKeymap.new(:left_keyboard, up: :w, down: :s, left: :a, right: :d, confirm: :left_control, back: :left_shift, start: :space),
#       KeyboardKeymap.new(:right_keyboard, up: :up_arrow, down: :down_arrow, left: :left_arrow, right: :right_arrow, confirm: :right_control, back: :right_shift, start: :enter),
#       ControllerKeymap.new(:controller_one, )
#     ]
#   end

#   def self.find(mapping)
#     all.find { |keymap| keymap.name == mapping }
#   end

#   def left_right
#     left_right_mapping = MAPPINGS[@mapping][:action][:left_right]

#     if left_right_mapping.is_a?(Array)
#       left, right = left_right_mapping.map do |key|
#         input.send(key) != false
#       end

#       DIRECTIONAL_MAPPING.fetch([left, right])
#     else
#       input.send(left_right_mapping)
#     end
#   end

#   def up_down
#     up_down_mapping = MAPPINGS[@mapping][:action][:up_down]

#     if up_down_mapping.is_a?(Array)
#       up, down = up_down_mapping.map do |key|
#         input.send(key) != false
#       end

#       DIRECTIONAL_MAPPING.fetch([up, down]) * -1
#     else
#       input.send(up_down_mapping)
#     end
#   end

#   def key_down(action)
#     input.key_down.send(MAPPINGS[@mapping][:action][action])
#   end

#   def key_up(action)
#     input.key_up.send(MAPPINGS[@mapping][:action][action])
#   end

#   class KeyboardKeymap < Keymap
#     def directional_vector
#       [left_right, up_down]
#     end
#   end

#   class ControllerKeymap < Keymap

#   end

#   private

#   def input
#     $game.inputs.send(MAPPINGS[@mapping][:input])
#   end
# end

# MAPPINGS = {
#   left_keyboard: {
#     input: :keyboard,
#     action: {
#       left_right: [:a, :d],
#       up_down: [:w, :s],
#       confirm: :left_control,
#       back: :left_shift,
#       start: :space,
#     }
#   },
#   right_keyboard: {
#     input: :keyboard,
#     action: {
#       left_right: [:left_arrow, :right_arrow],
#       up_down: [:up_arrow, :down_arrow],
#       confirm: :right_control,
#       back: :right_shift,
#       start: :enter,
#     }
#   },
#   controller_one: {
#     input: :controller_one,
#     action: {
#       left_right: :left_analog_x_perc,
#       up_down: :left_analog_y_perc,
#       confirm: :a,
#       back: :b,
#       start: :start,
#     }
#   },
#   controller_two: {
#     input: :controller_two,
#     action: {
#       left_right: :left_analog_x_perc,
#       up_down: :left_analog_y_perc,
#       confirm: :a,
#       back: :b,
#     }
#   },
#   controller_three: {
#     input: :controller_three,
#     action: {
#       left_right: :left_analog_x_perc,
#       up_down: :left_analog_y_perc,
#       confirm: :a,
#       back: :b,
#     }
#   },
#   controller_four: {
#     input: :controller_four,
#     action: {
#       left_right: :left_analog_x_perc,
#       up_down: :left_analog_y_perc,
#       confirm: :a,
#       back: :b,
#     }
#   }
# }
