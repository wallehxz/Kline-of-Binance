# t.integer  "chain_id",   limit: 8
# t.float    "o_price",    limit: 24
# t.float    "c_price",    limit: 24
# t.float    "h_price",    limit: 24
# t.float    "l_price",    limit: 24
# t.float    "volume",     limit: 24
# t.date     "diary"
# t.decimal  "time_stamp",            precision: 15

class Market < ActiveRecord::Base
  self.per_page = 20
  validates_uniqueness_of :time_stamp, scope: :chain_id
  scope :latest, ->{ order(time_stamp: :desc) }
  scope :timing, ->{ order(time_stamp: :asc) }

  def self.generate(block,data,time_stamp)
    m = Market.new
    m.chain_id = block
    m.o_price = data[1]
    m.h_price = data[2]
    m.l_price = data[3]
    m.c_price = data[4]
    m.volume = data[9]
    m.diary = Time.at(time_stamp).strftime('%F')
    m.time_stamp = time_stamp
    m.save
  end

  def self.intact_time(stamp)
    intact = Time.at(stamp).beginning_of_minute.to_i
    if stamp.to_i - intact > 30
      return intact + 60
    else
      return intact
    end
  end

end
