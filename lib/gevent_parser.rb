require "gevent_parser/version"

module GeventParser
  require 'json'
  require 'colors'

  class Parser

    def read
      while l = gets
        if s = parse(l)
          puts s
        end
      end
    end

    def format_author(author)
      "#{author['name'].hl(:lightblue)}(#{'@'.hl(:gray)}#{author['username'].hl(:gray)})"
    end

    def get_author(event)
      if event['type'] == 'patchset-created'
        event['uploader']
      else
        event['author']
      end
    end

    def format_change(event)
      s = ''
      if event['patchSet']
        s = "r#{event['patchSet']['number']}".hl(:gray)
      end
      s + ":\##{event['change']['number'].hl(:lightblue)}(#{event['change']['project'].hl :yellow})" +
        " \"#{event['change']['subject'].hl :gray}\""
    end

    def get_approval(event)
      approval = -2
      if event and event['approvals']
        event['approvals'].each { |app|
          approval = [approval, app['value'].to_i].max # This is an ugly shortcuts that doesn't handle all the different possible cases
        }
      end
      approval
    end

    def parse_build_event(e)
      author = get_author(e)['username']
      if author =='builder'
        if get_approval(e) == 2
          "Build for patchset #{format_change e}".hl(:green) + ' is successful'.hl(:green)
        elsif  get_approval(e) == -1
          "Build for patchset #{format_change e}".hl(:red) + ' has failed'.hl(:red)
        else
          "Build for patchset #{format_change e} started"
        end
      elsif author == 'bot'
        if get_approval(e) == 1
          "Review Bot is happy with #{format_change e}".hl :green
        else
          "Review Bot is not happy with #{format_change e}".hl :red
        end
      elsif author == 'sonar'
        if get_approval(e) == 1
          "Sonar is pleased with #{format_change e}".hl :green
        else
          "Sonar is not pleased with #{format_change e}".hl :red
        end
      end
    end

    def parse_comment(event)
      if get_approval(event) == 2
        "#{format_author event['author']}" + " +2'ed ".hl(:green) + "#{format_change event}!".hl(:green)
      elsif get_approval(event) == 1
        "#{format_author event['author']} +1'ed #{format_change event}"
      elsif get_approval(event) == -1
        "#{format_author event['author']}" + " -1'ed " + "#{format_change event}".hl(:red)
      elsif get_approval(event) == -2
        "#{format_author event['author']}" + " -2'ed ".hl(:red) + "#{format_change event}".hl(:red)
      else
        "#{format_author event['author']} commented on #{format_change event}"
      end
    end

    def parse(line)
      begin
        h = JSON.parse line
        if h['type'] == 'comment-added'
          author = get_author(h)['username']
          if author == 'builder' or author == 'bot' or author == 'sonar'
            parse_build_event h
          else
            parse_comment h
          end
        elsif h['type'] == 'patchset-created'
          "#{format_author h['uploader']}" + ' has created '.hl(:green) + "#{format_change h}" + '!'.hl(:green)
        elsif h['type'] =='change-abandoned'
          "#{format_author h['abandoner']}" + ' has abandoned '.hl(:red) + "#{format_change h}" + '!'.hl(:red)
        elsif h['type'] == 'change-merged'
          'Change '.hl(:green) + "#{format_change h}" + ' has been merged !'.hl(:green)
        elsif h['type'] == 'ref-updated'
          # Do nothing...
        elsif h['type'] == 'reviewer-added'
          "#{format_author h['reviewer']} has been added as reviewer on #{format_change h}"
        elsif h['type'] =~ /ref-replicat[a-z\-]+/
          # Do nothing...
        else
          puts "Unhandled event:\n#{line}"
        end
      rescue Exception => e
        puts "Something failed! #{e}"
        e.backtrace.each { |l|
          puts "\t#{l}"
        }
        puts line
      end
    end
  end
end