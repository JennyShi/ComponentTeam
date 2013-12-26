require 'rally_api_emc_sso' 

class ComponentTeam
  
  def initialize (workspace,project)
    headers = RallyAPI::CustomHttpHeader.new()
    headers.name = 'My Utility'
    headers.vendor = 'MyCompany'
    headers.version = '1.0'

    #==================== Making a connection to Rally ====================
    config = {:base_url => "https://rally1.rallydev.com/slm"}
    config = {:workspace => workspace}
    config[:project] = project
    config[:headers] = headers #from RallyAPI::CustomHttpHeader.new()

    @rally = RallyAPI::RallyRestJson.new(config)
    #puts "Workspace #{@workspace}"
    #puts "Project #{@project}"
  end
  
  def setup(row)
  
    @feature = find_feature(row)
    if (@feature == nil)
      puts "No #{row["Formatted ID"]}, can't set ComponentTeam"
    else
      puts "Find feature #{row["Formatted ID"]}"
     # @componentTeam = find_componentTeam(row)
     # if(@componentTeam == nil)
     #   puts "Can't find the ComponentTeam #{row["Target Area"]}!"
     # else
        update_componentTeam(row)
        puts "#{row["Formatted ID"]} updated"
      end
   # end
    puts "\n"
  end
  
  def find_feature(row)
    query = RallyAPI::RallyQuery.new()
    query.type = "portfolioItem"
    query.fetch = "Name,FormattedID"
    query.query_string = "(FormattedID = \"#{row["Formatted ID"]}\")"
    results = @rally.find(query)
  
 # result.first.read
 # puts result.first.read.Children.size
  
    if (results.length != 0)
      results.each do |res|
        res.read
        puts "Find #{res.FormattedID}"
       # puts res.Tags.Name
      end
    else
      puts "No such feature #{row["Formatted ID"]}"
    end
    results
  end
 
 
  def find_componentTeam(row)
    query = RallyAPI::RallyQuery.new()
    query.type = "portfolioItem"
    query.fetch = "ComponentTeam"
    query.query_string = "(c_ComponentTeam = \"#{row["Target Area"]}\")"
    results = @rally.find(query)
    
    if (results != nil)
      #results.read
      puts "Find the ComponentTeam #{row["Target Area"]}!"
      results.each do |res|
        res.read
        puts "ComponentTeam: #{res.ComponentTeam}"
      end
    else
      puts "No such componentTeam #{row["Target Area"]}!"
    end
    results
  end

  def update_componentTeam(row)
    puts "updating..."
    #puts @feature["FormattedID"]
    #puts @componentTeam["_ref"]
    field = {}
    field["ComponentTeam"] = row["Target Area"]
    #field["c_ComponentTeam"] = row["Target Area"]
    
    @rally.update("portfolioItem","FormattedID|#{@feature["FormattedID"]}",field)
    puts "#{row["Formatted ID"  ]} updated"
  end
end