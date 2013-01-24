class HarvestWorker
  include Sidekiq::Worker

  def perform(harvest_job_id)
    job = HarvestJob.find(harvest_job_id)
    self.update_as_started(job)

    begin
      parser = job.parser
      parser.load
      records = parser.loader.parser_class.records
      records.each do |record|
        self.process_record(record, job)
      end
    rescue StandardError => e
      job.harvest_job_errors.create(exception_class: e.class, message: e.message, backtrace: e.backtrace[0..5])
    end

    self.update_as_finished(job)
  end

  def update_as_started(job)
    job.start_time = Time.now
    job.save
  end

  def process_record(record, job)
    begin
      self.post_to_api(record)
    rescue StandardError => e
      job.harvest_job_errors.build(exception_class: e.class, message: e.message, backtrace: e.backtrace[0..5])
    end
    job.records_harvested += 1
    job.save
  end

  def post_to_api(record)
    begin
      attributes = record.attributes
      RestClient.post "#{ENV["API_HOST"]}/harvester/records.json", {record: attributes}.to_json, :content_type => :json, :accept => :json
    rescue StandardError => e
      Rails.logger.info "Harvest Error: #{e.message}"
    end
  end

  def update_as_finished(job)
    job.end_time = Time.now
    job.save
  end
end
