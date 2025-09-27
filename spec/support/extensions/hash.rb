# Removed custom to_json method to avoid conflicts with modern JSON gem
# class Hash
#
#   def to_json(*args)
#     MultiJson.dump(self)
#   end
# end
