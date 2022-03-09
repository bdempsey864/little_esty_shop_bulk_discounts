class HolidayService
  def self.holidays(data)
    uri = Faraday.new(url: "https://date.nager.at")
    json = JSON.parse(uri.get("/api/v1/Get/#{data[:country]}/2022").body, symbolize_names: true)
    holidays = []
    json.each do |holiday|
      if holiday[:date] >= Time.now
        holidays << Holiday.new(holiday)
        break if holidays.length == data[:number]
      end
    end
    holidays
  end
end