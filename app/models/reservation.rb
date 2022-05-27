Reservation = Struct.new(:id, :status, :covers, :walk_in, :start_time, :duration, :notes, :guest, :restaurant, :tables) do

  attr_accessor :created_at, :updated_at

  def initialize(*args)
    super(*args)

    @created_at, @updated_at = Time.current, Time.current
  end

  def id
    self['id'].presence || SecureRandom.uuid
  end

  def created_at
    @created_at
  end

  def updated_at
    @updated_at
  end


end