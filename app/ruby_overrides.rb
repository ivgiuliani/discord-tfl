# frozen_string_literal: true

class String
  def truncate(max)
    length > max ? (self[0...max]).to_s : self
  end

  def title
    gsub(/\b(?<!\w['’`])[a-z]/, &:capitalize)
  end

  alias_method :titleize, :title
end
