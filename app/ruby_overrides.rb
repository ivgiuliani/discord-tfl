# frozen_string_literal: true

class String
  def truncate(max)
    length > max ? (self[0...max]).to_s : self
  end
end
