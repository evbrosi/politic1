class HomeController < ApplicationController
  def index
		@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NE KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC PR)
		@states.sort!
  		
  	if params[:state] != nil

  		@state = params[:state]

  		@contributions = {"Less than $2,700" => 2700, "Less then $10,000" => 10000, "Less than $100,000" => 100000, "Everything else"  => 10000000000000000}

  		@parties = ["D","R","I"]
  		#{"Democrat" => "D", "Republican" => "R", "Independent" => "I"}
  		
  		@in_states = {"In State Money" => "yes", "Outsider Cash" => "no"}

		results = HTTParty.get("http://transparencydata.com/api/1.0/contributions.json?amount=%3E%7C0001&cycle=2015&recipient_state=#{params[:state]}&apikey=#{ENV['sunlight_api_key']}")

		@result = results

		@check_number = 0
		@state_total = 0
		@result.each do |r|
			@state_total += r["amount"].to_f
			@check_number += 1
		end

		@state_check=[]
		@result.each do |r|
			if params[:state] == r["contributor_state"]
				@state_check.push(r["contributor_state"])
				@check_states == "yes"
			else
				@state_check.push(r["contributor_state"])
				@check_states == "no"
			end
		end

		@politicians = []
		@result.each do |r|
			@politicians.push(r["recipient_name"])
		end
		@politicians.uniq!

		@politician = params[:politicians]

		@givers = []
		@result.each do |r|
			@givers.push(r["contributor_name"])
		end
		@givers.uniq!

		@giver = params[:givers]

		if params[:contributions].present?
			@temp_arr = []

			@result.each do |r|
				if params[:contributions].to_f > r["amount"].to_f
					@temp_arr.push(r)
				end
			end
			@result = @temp_arr
		end

		if params[:in_state].present?
			@temp_arr = []

			@result.each do |r|
				if params[:in_state] == "yes" && (params[:state] == r["contributor_state"] || r["contributor_state"] =="")
					if r["contributor_city"] != ""
						@temp_arr.push(r)
					end
				elsif params[:in_state] == "no" && (params[:state] != r["contributor_state"] || r["contributor_city"] == "") 
						@temp_arr.push(r)			
				end
			end

			@result = @temp_arr
		end

		if params[:party].present?
			@temp_arr = []

			@result.each do |r|
				if params[:party] == r["recipient_party"]
					@temp_arr.push(r)
				end
			end
			@result = @temp_arr
		end

		if params[:politician].present?
			@temp_arr = []

			@result.each do |r|
				if params[:politician] == r["recipient_name"]
					@temp_arr.push(r)
				end
			end
			@result = @temp_arr
		end

		if params[:giver].present?
			@temp_arr = []

			@result.each do |r|
				if params[:giver] == r["contributor_name"]
					@temp_arr.push(r)
				end
			end
			@result = @temp_arr
		end

		@total = 0
		@result.each do |r|
			@total += r["amount"].to_f		
		end
	end
end
end