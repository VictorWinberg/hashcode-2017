infile = ARGV[0]

file = File.new(infile, "r")
first_line = file.gets.split(' ').map(&:to_i)

n_videos = first_line[0]
n_endpoints = first_line[1]
n_requests = first_line[2]
n_caches = first_line[3]
cache_size = first_line[4]

video_sizes = file.gets.split(' ').map(&:to_i)

rand = Random.new

# {enpoint_id => {cache_id => latency}}
endpoints = Hash.new {|hash, key| hash[key] = {}}
endpoint_datacenter_lat = {}

n_endpoints.times do |i|
  e = file.gets.split(' ').map(&:to_i)
  endpoint_datacenter_lat[i] = e[0]
  endpoint_caches = e[1]

  endpoint_caches.times do |j|
    e_cache = file.gets.split(' ').map(&:to_i)
    cache_id = e_cache[0]
    cache_latency = e_cache[1]

    endpoints[i][cache_id] = cache_latency
  end
end

videos = Hash.new(0)

cache_requests = Hash.new { |hash, key| hash[key] = Array.new(n_videos, 0) }
all_requests = []

n_requests.times do |i|
  print("\r#{i}/#{n_requests}             ") if i % 100 == 0
  r = file.gets.split(' ').map(&:to_i)
  request_video = r[0]
  request_endpoint = r[1]
  request_amount = r[2]

  # # if connected
  # # for each cache
  # n_caches.times do |j|
  #   # print("\r#{i}/#{n_requests} #{j}/#{n_caches}             ")
  #   # if endpoint is connected to cache
  #   cache_has_endpoint = endpoints[request_endpoint].keys.include?(j)
  #   if cache_has_endpoint
  #     cache_requests[j][request_video] = 1
  #   end
  # end
  all_requests << [request_video, request_endpoint, request_amount]
  videos[request_video] += request_amount
end

all_requests.sort_by {|a| a[0]}

def find_sorted_request(requests, video_id)
  i = 0

  a = requests.bsearch do |x|
    x >= video_id
  end

  # while i < requests.length
  #   return nil if requests[i][0] > video_id
  #   return requests[i] if requests[i][0] == video_id
  #   i += 1
  # end
  nil
end


find_sorted_request(all_requests, 1)

exit

videos = videos.sort_by {|k,v| v}.reverse

caches = {}
caches_rem_size = {}
n_caches.times do |i|
  caches[i] = []
  caches_rem_size[i] = cache_size
end

n_caches.times do |i|
  print("\r#{i}/#{n_caches}             ")
  rem_size = caches_rem_size[i]

  retries = 0
  videos_copy = videos.dup
  while rem_size > 0 && retries < 500
    #video = videos_copy[rand.rand([videos_copy.size, 10].min)][0]
    video = videos_copy[rand.rand([videos_copy.size, 100].min)][0]
    video_size = video_sizes[video]
    next if video_size > (cache_size / 2)

    request = find_sorted_request(all_requests, video)
    next if !request
    request_endpoint = request[1]
    next if !endpoints[request_endpoint].keys.include?(i)
    #next if cache_requests[i][video] == 0

    if rem_size - video_size >= 0 && !caches[i].include?(video)
      videos_copy.pop
      caches[i] << video
      rem_size -= video_size
    else
      retries += 1
    end
  end
end


File.open("#{infile}.out", "w") do |file|
  used_caches = n_caches
  file.write("#{used_caches}\n")
  used_caches.times do |i|
    file.write("#{i} #{caches[i].join(' ')}\n")
  end
end
#puts(caches)
