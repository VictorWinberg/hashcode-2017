infile = ARGV[0]

file = File.new(infile, "r")
first_line = file.gets.split(' ').map(&:to_i)

n_videos = first_line[0]
n_endpoints = first_line[1]
n_requests = first_line[2]
n_caches = first_line[3]
cache_size = first_line[4]

video_sizes = file.gets.split(' ').map(&:to_i)
sorted_video_sizes = video_sizes.each_with_index.map {|x,i| [i, x]}.sort {|a,b| a[1] <=> b[1]}.reverse

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

caches = {}
caches_rem_size = {}
n_caches.times do |i|
  caches[i] = []
  caches_rem_size[i] = cache_size
end

strategy = 
  case infile
  when './kittens.in'
    'random'
  when './me_at_the_zoo.in'
    'sort'
  when './trending_today.in'
    'sort'
  when './videos_worth_spreading.in'
    'sort_dup'
  else
    'random'
  end
puts("#{infile} #{strategy}")

if strategy == 'random'
  n_caches.times do |i|
    rem_size = caches_rem_size[i]

    retries = 0
    #c_sorted_video_sizes = sorted_video_sizes.dup
    while rem_size > 0 && retries < 1000
      print("\r#{i}/#{n_caches} r:#{retries}            ")
      video = rand.rand(n_videos)
      video_size = video_sizes[video]
      
      #v = c_sorted_video_sizes[0]
      #video = v[0]
      #video_size = v[1]

      if rem_size - video_size >= 0 && !caches[i].include?(video)
        #c_sorted_video_sizes.pop
        caches[i] << video
        rem_size -= video_size
      else
        retries += 1
      end
    end
  end
elsif strategy == 'sort_dup'
  n_caches.times do |i|
    rem_size = caches_rem_size[i]

    retries = 0
    c_sorted_video_sizes = sorted_video_sizes.dup
    while rem_size > 0 && retries < 1000
      print("\r#{i}/#{n_caches} r:#{retries}            ")
      #video = rand.rand(n_videos)
      #video_size = video_sizes[video]
      
      v = c_sorted_video_sizes[0]
      video = v[0]
      video_size = v[1]

      if rem_size - video_size >= 0 && !caches[i].include?(video)
        c_sorted_video_sizes.pop
        caches[i] << video
        rem_size -= video_size
      else
        retries += 1
      end
    end
  end
elsif strategy == 'sort'
  n_caches.times do |i|
    rem_size = caches_rem_size[i]

    retries = 0
    #c_sorted_video_sizes = sorted_video_sizes.dup
    while rem_size > 0 && retries < 1000
      print("\r#{i}/#{n_caches} r:#{retries}            ")
      #video = rand.rand(n_videos)
      #video_size = video_sizes[video]
      
      v = sorted_video_sizes[0]
      video = v[0]
      video_size = v[1]

      if rem_size - video_size >= 0 && !caches[i].include?(video)
        sorted_video_sizes.pop
        caches[i] << video
        rem_size -= video_size
      else
        retries += 1
      end
    end
  end
end

file = File.new("#{infile}.out", "w")


File.open("#{infile}.out", "w") do |file| 
  used_caches = n_caches
  file.write("#{used_caches}\n")
  used_caches.times do |i|
    file.write("#{i} #{caches[i].join(' ')}\n")
  end
end
#puts(caches)

