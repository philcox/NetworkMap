require 'rubygems'
require 'json'
require 'pp'

#Setup some constant things I know to get this done quicker
@prodacct = "owner:5867-8934-6966"
@svcacct = "owner:0418-1922-9125"
@stageacct = "owner:1926-6414-0639"
@biacct = "owner:2276-4563-8362"
@oldprod =  "owner:6352-0171-9205"
@testacct = "owner:8266-9318-1925"

filein = ARGV[0]
fileout = ARGV[1]

#Usage is input json file and output a csv

json = File.read(filein)
stuff = JSON.parse(json)

depl = stuff["deployments"]

secgrp = stuff["groups"]

@arrayctr = 0
@holder = Array.new

secgrp.each do |x|
  @sgn = x[0]
  @sgname = x[1]["name"]
  @sgcloud = x[1]["cloud"]
  ports = stuff["ports"]
  ports.each do |y|
   y.each do |z|
       if z.class == Array
            z.each do |w|
              if w["group"].to_s == @sgn
                # add an IF check to convert SG numbers to "SG FOO in another cloud associated with the current account"
                case w["source"]
                 when /#{@prodacct}\/.*/
                   foo = w["source"].gsub(/#{@prodacct}/,'Production Account')
                   w["source"] = foo
                  when /#{@svcacct}\/.*/
                    foo = w["source"].gsub(/#{@svcacct}/,'Services Account')
                    w["source"] = foo
                  when /#{@stageacct}\/.*/
                    foo = w["source"].gsub(/#{@stageacct}/,'Stage Account')
                    w["source"] = foo
                  when /#{@biacct}\/.*/
                    foo = w["source"].gsub(/#{@biacct}/,'BI Account')
                    w["source"] = foo
                  when /#{@oldprod}\/.*/
                    foo = w["source"].gsub(/#{@oldprod}/,'Old Production Account')
                    w["source"] = foo
                  when /#{@testacct}\/.*/
                    foo = w["source"].gsub(/#{@testacct}/,'Test Account')
                    w["source"] = foo
                  when /0.0.0.0\/0/
                    foo = w["source"].gsub(/0.0.0.0\/0/,'Anyone')
                    w["source"] = foo
                  else
                end
                if (w["proto"].eql?("icmp") | w["ports"].eql?("22"))
                  else
                  @holder[@arrayctr] = @sgn , @sgname , @sgcloud , w["ports"] , w["source"] , w["proto"]
                  @arrayctr += 1
                end
              end
            end
       end
   end
  end



end

@arrayctr = 0
@final = Array.new

vms = stuff["instances"]

vms.each do |k|
  @holder.each do |m|
    @ctr2 = m
  if k[0] == @ctr2[0]
    k[1].each do |n|
      # puts n["name"] + " allows port " + @ctr2[3] + "/" + @ctr2[5] + " access to " +  @ctr2[4]
      @final[@arrayctr] = n["name"] , @ctr2[3], @ctr2[5] , @ctr2[4]
      @arrayctr += 1
    end
  end
  end
end

@fsort = @final.sort

output = File.open(fileout, "w")


@fsort.each do |o|
  output.puts o.to_s
end

output.close

# Now try to pretty it up a bit to show the host and all the allowed inbound
@srvnmctr = 0
@srvnamlst = Array.new

@final.each do |getsrvname|
  if @srvnamlst =~ getsrvname[0].to_s
  else
    @srvnamlst[@srvnmctr]= getsrvname[0].to_s
    #puts @srvnamlst
    @srvnmctr =+ 1
  end
  #puts @srvnamlst
end
#puts @srvnamlst

@srvnamlst.each do |srvnam|
  @srvnam = srvnam
 # puts @srvnam
  @final.each do |frows|
 #   puts "space"
 #   puts frows
    if frows =~ /@srvnam/

    end
  end
end