require 'twitter'
require 'tweetstream'

$tt_ks = [
	[8, 35, "徳山駅前", "08:58", "二番町 銀座", "no"],
	[9,5, "徳山駅前", "09:28", "二番町 銀座", "年末年始運休"],
	[9, 20, "徳山駅前", "09:37", "桜木 速玉町", "no"],
	[13, 0, "徳山駅前", "13:17", "桜木 速玉町", "no"],
	[15, 40, "徳山駅前", "15:57", "桜木 速玉町", "no"],
	[16, 20, "徳山駅前", "16:37", "桜木 速玉町", "no"],
	[17, 18, "徳山駅前", "17:35", "球場前 速玉町", "高専登校日運行"],
	[17, 25, "徳山駅前", "17:48", "二番町 銀座", "no"],
	[17, 55, "下松駅前", "18:06(櫛ケ浜駅)", "櫛ヶ浜駅前", "no"],
	[18, 02, "徳山駅前", "18:25", "二番町 銀座", "no"],
	[18, 27, "徳山駅前", "18:50", "二番町 銀座", "no"],
	[19, 27, "徳山駅前", "19:50", "二番町 銀座", "終バス "],
]

$saigo = 11

YOUR_CONSUMER_KEY = ""
YOUR_CONSUMER_SECRET = ""
YOUR_ACCESS_TOKEN = ""
YOUR_ACCESS_SECRET = ""

@client = Twitter::REST::Client.new do |config|
  config.consumer_key        = YOUR_CONSUMER_KEY
  config.consumer_secret     = YOUR_CONSUMER_SECRET
  config.access_token        = YOUR_ACCESS_TOKEN
  config.access_token_secret = YOUR_ACCESS_SECRET
end

def get_time_now
	$time_now = Time.now.strftime("%X").to_s
	$time_now = $time_now[0,5]
	return $time_now
end

def get_time(h,m)
	time_30m = h * 60 + m
	hour = time_30m / 60
	min = time_30m % 60	
	str1 = hour.to_s
	str2 = min.to_s
	if hour < 10
		str1 = '0' + str1
	end
	if min < 10
		str2 = '0' + str2
	end		
	str = str1 + ':' + str2
	return str
end

def get_time_15m(h,m)
	time_30m = h * 60 + m - 15 #-mmで何分前か指定
	hour = time_30m / 60
	min = time_30m % 60	
	str1 = hour.to_s
	str2 = min.to_s
	if hour < 10
		str1 = '0' + str1
	end
	if min < 10
		str2 = '0' + str2
	end		
	str = str1 + ':' + str2
	return str
end
	
i=0

loop do
	if get_time_15m($tt_ks[i][0],$tt_ks[i][1]) == get_time_now
		str = get_time($tt_ks[i][0],$tt_ks[i][1])+"発 "+$tt_ks[i][2]+"行き("+$tt_ks[i][3]+"到着) "+$tt_ks[i][4]+"経由 "
		if $tt_ks[i][5] != "no"
			str = str + "※" + $tt_ks[i][5].to_s
		end
		str = str + "発車15分前です。"
		@client.update(str)
		puts str
		sleep 60
	end
		if get_time($tt_ks[i][0],$tt_ks[i][1]) == get_time_now
		str = get_time($tt_ks[i][0],$tt_ks[i][1])+"発 "+$tt_ks[i][2]+"行きが発車しました。次のバスは"
		if i==$saigo
			str = str + "もうありません..."
		else
			str = str + get_time($tt_ks[i+1][0],$tt_ks[i+1][1]) + "発" + $tt_ks[i+1][2] + "行きです。"
			if $tt_ks[i][5] != "no"
				str = str + "※" + $tt_ks[i][5].to_s
			end
		end
		@client.update(str)
		puts str
		sleep 60
	end

	i=i+1
	if i==$saigo+1 #配列の長さに応じて変える
		i=0
	end
end

