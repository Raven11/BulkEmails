class EmailerController < ApplicationController

	def index
	end
	def csv_import
		file_data = params[:file].read
		str = file_data.gsub(/\".*?\s.*?\"/){|m| m.gsub!(/\n/,'')}
		csv_rows = CSV.parse(str, :quote_char => "\x00")
		ENV["MANDRILL_USERNAME"] = params[:username]
		ENV["MANDRILL_PASSWORD"] = params[:api_key]
		set_mailer_settings
		subject = params[:subject]
		message = params[:message]
		from = params[:from_address]
		from_name = params[:from_name]     
		csv_rows.each do |row|
			name, *emails = row
			unique_emails = emails.uniq
			#name = row[0]
			#email = row[1]
			message = message.gsub(/<name>/,"#{name}")	   	 
			unique_emails.each{ |email|
				fine_email = email.gsub(/\"/,'').strip
				Emailer.contact_mail(name, subject, message, fine_email, from_name, from).deliver
			}
		end

		respond_to do |format|
			format.html {redirect_to root_path, notice: 'CSV uploaded and emails sent successfully'}
		end
	end
	
	private
	def set_mailer_settings
		ActionMailer::Base.smtp_settings = {
			:address  => "smtp.mandrillapp.com",
			:port     => 587,
			:enable_starttls_auto => true, # detects and uses STARTTLS
			#:user_name => "eashan@crypsis.net",
			#:password  => "xi7bsYdV1G06QzURzikPKA",
			:user_name => ENV["MANDRILL_USERNAME"], #"eashan@crypsis.net",
			:password  => ENV["MANDRILL_PASSWORD"], #"xi7bsYdV1G06QzURzikPKA",
			:authentication => 'login',
			:domain => "crypsis.net"
		}
	end
end	
