# whitespace of any kind as delimiter
# contiguous word characters \w+ as word-tokens
# sentence punctuation characters as sentence-end-token, sentence-begin-token
# end of stream as sentence-end-token
#
class UndefinedStreamError < StandardError  
end  

class InputStreamParser
    def parse()
        return _parse(@stream) if defined? @stream
        raise UnderfinedStreamError, "InputStream stream is not defined"
    end
end

class StringParser < InputStreamParser
    @@regex = /\w+|\w+[-'&]+\w+|[^\w\s]+/
    def initialize(someString)
        @stream=someString
    end

    def _parse(stream)
        stream.scan(@@regex)
    end
end


class DirectedWeightedGraph
    attr_accessor  :vertices

    def initialize(parser)

        @vertices={ 
            :start_sentence => {},
            ".".to_sym => { :end_sentence => 1 },
            "!".to_sym => { :end_sentence => 1 },
            "?".to_sym => { :end_sentence => 1 },
        }

        most_recent_token = :start_sentence

        parser.parse.each_with_index do |chunk, index| 
            token = chunk.strip.downcase.to_sym

            next if token.to_s.empty?

            @vertices[most_recent_token][token] ||= 0
            @vertices[most_recent_token][token] += 1 

            @vertices[token] ||= { } 

            most_recent_token = token
            most_recent_token = :start_sentence if is_sentence_end?(most_recent_token) 
        end

        # If the stream ended without punctuation, 
        # pretend a period was present.
        @vertices[most_recent_token][".".to_sym] ||= 1
    end

    def generate()
        most_recent_token = :start_sentence
        sentence=[]
        while true
            selected_option = selection(@vertices[most_recent_token])
            break if selected_option == :end_sentence
            sentence.push(selected_option.to_s)
            most_recent_token = selected_option
        end
        sentence.join(" ").capitalize.gsub(/\s+([“".\?\!\,])/,'\1').gsub(/\s([-’'])\s/,'\1')
    end

    protected
    def selection(options)
        current = 0
        max = options.values.reduce(0,:+)
        random_value = rand(max) + 1
        options.each do |key,val|
            current += val
            return key if random_value <= current
        end
    end

    def is_sentence_end?(token)
        token == ".".to_sym || token == "!".to_sym || token == "?".to_sym
    end
end

p=StringParser.new(DATA.read)

dwg = DirectedWeightedGraph.new(p)
puts (1..8).map{ dwg.generate }.join(" ")

# require 'pp' 
# pp(dwg.vertices)

=begin
{
    :start_sentence => {
        "the"  => 1,
        "they" => 1,
        "have" => 1
    },
    "the" => {
        "dog" => 2,
        "street" => 1
    },
    "they" => {
        "have" => 1
    },
    "have" => {
        "no" => 1,
        "you" => 1
    },
    "dog" => {
        "ran" => 1,
        :end_period => 1,
        :end_question => 1
    },
    "street" => {
        :end_period => 1
    },
    "no" => {
        "dog" => 1
    },
    "ran" => {
        "up" => 1
    },
    "up" => {
        "the" => 1
    },
    "you" => {
        "seen" => 1
    },
    "seen" => {
        "the" => 1
    }
}

The dog ran up the street.
They have no dog.
Have you seen the dog?
=end

__END__
 As he described the factors that went into his decision to keep American troops in Afghanistan, the one word President Obama did not mention on Thursday was Iraq.

Four years ago, he stuck to his plan to pull out of Iraq, only to watch the country collapse back into sectarian strife and a renewed war with Islamic extremists. Facing a similar situation in Afghanistan, Mr. Obama has decided not to follow a similar course.

Whether keeping a residual American force in Iraq would have made a difference is a point of contention, but the president chose not to take a chance this time. In seeking to avoid a repeat of the Iraq meltdown by keeping 9,800 troops in Afghanistan next year and 5,500 after he leaves office, he abandoned his hopes of ending the two wars he inherited.

In Reversal, Obama Says U.S. Soldiers Will Stay in Afghanistan to 2017OCT. 15, 2015
NATO soldiers at the scene of a car bomb on Sunday in Kabul, Afghanistan. NATO has 17,000 troops in Afghanistan; 9,800 of those are from the United States.Obama Is Rethinking Pullout in Afghanistan, Officials SayOCT. 14, 2015
Chadian troops training with American Special Forces in February.To Aid Boko Haram Fight, Obama Orders 300 Troops to CameroonOCT. 14, 2015
Russian soldiers with their plane, a Sukhoi Su-34 strike fighter, which NATO calls a Fullback, this month in Latakia, Syria.Russian Military Uses Syria as Proving Ground, and West Takes NoticeOCT. 14, 2015
NATO soldiers and Afghan security forces at the site of a suicide car bombing in Kabul on Sunday.Afghan Taliban’s Reach Is Widest Since 2001, U.N. SaysOCT. 11, 2015
Dr. Joanne Liu, the president of Doctors Without Borders, spoke on Wednesday in Geneva.Obama Issues Rare Apology Over Bombing of Doctors Without Borders Hospital in AfghanistanOCT. 7, 2015
While not openly drawing lessons from the Iraq withdrawal, Mr. Obama drew an implicit distinction by emphasizing that the new Afghan government of President Ashraf Ghani, unlike the Baghdad government in 2011, still supported an American military presence and has taken the legal steps to make it possible.

    The Southeast Regional Library here in this town will close for renovations on Oct. 24 at 6 p.m, Wake County officials announced Thursday.

The book return will remain open until Oct. 30 at 5 p.m.

The library will resume its services in the old police headquarters at 900 7th Ave., when the department moves out and into its new building, which is now expected to be around Nov. 9, according to town officials.

The library will be able to take possession of the building on Nov. 12, Rick Mercier, town spokesman, said.

“These dates are tentative and subject to Calvin Davenport, Inc., being able to complete construction on this updated timeline,” he said.

The Police Department was supposed to move into their new building in September, but delays to construction in August caused that date to be pushed back to Oct. 5. That date has been pushed back once again.

The town has offered the library to use its old police headquarters as a temporary space, while they undergo renovations. They hope to limit the amount of time Garner will be without library services.

So whenever, the police department moves in, the library can move in. The library will up-fit the building and move furniture and computers to the new space, which is across the parking lot.

“It would take us about two weeks to up-fit it and put the library in it,” Deputy Library Director Ann Burlingame said. “We want to turn it around as quickly as possible.”

She said the ideal date to move into the new space would be no later than Dec. 1. Wake County will be closed during the Thanksgiving holidays.

The temporary library will offer children’s programming, limited public computers, book request service and a book return.

The library is being renovating with new carpet, paint, lighting, new furnishings and an updated floor plan to enhance the library, making it more user-friendly. Southeast Regional Library is expected to re-open in April 2016.

A Durham woman was charged Thursday with killing her 2-week-old daughter in June, police said.1

Twila Mae Beunier, 30, was charged with murder and felony child abuse and was being held without bond in the Durham County jail.1

Police responded to a cardiac arrest call at 917 Rome Ave. on June 6, and Briseida Abarada was pronounced dead at the scene.1

An autopsy indicated the baby had suffered head injuries, and the Medical Examiner's Office recently ruled her death a homicide, police said.

    Did somebody at least do something to help the chubby dude leaning up against the lamp post?

While city officials are rightfully concerned with the way Raleigh was portrayed to the outside world in a recent newspaper ad featuring a portly port-chugger, I – being sensitive to a fault – was more worried about the kid.

The millennial-looking lush, clad in the male millennial’s official party-time, fashion-backward outfit of untucked dress shirt and blue jeans, appears to be green around the gills, two sheets to the wind, about to call Earl.

In other words, he looks lit up like a Christmas tree.

Who is he? I fretted. Did somebody call him a cab? Get him a barf bag? The phone number to AA?

Janet Cooke, a reporter for the Washington Post, once wrote a story about an 8-year-old heroin addict that sent D.C. officials and cops on a desperate humanitarian mission to find and save him.

Turned out that the prepubescent drug abuser existed only in Cooke’s amoral, ambitious mind, and thousands of dollars in money and manpower were wasted hunting for a “victim” who didn’t even exist.

Neither did the drunk dude in the lamp post ad, so relax.

He was, according to Dean Debnam, the Raleigh businessman who led the political push against downtown bars, “(j)ust an actor our vendor hired” and he made it home safely. “Sadly, however, that isn’t always the case for the patrons of the bars downtown.” An N&O story identified the lamp-post leaner as a recent N.C. State University grad.

When I asked Debnam if he thought the ad was effective in shaping the election, he said, “I know the ad was effective because I own a polling company, and like we tell our clients, there is no reason to guess when you can know.”

He also cited as proof of the ad’s effectiveness that incumbent councilwoman Mary Ann Baldwin (portrayed by some opponents as the pro-puking, pro-partying downtown candidate) came out ahead of incumbent Russ Stephenson with less than 1 percent of the vote. (Both Baldwin and Stephenson were easily re-elected in the at-large race.) And, Debnam said, every pro bar candidate except Baldwin and Bonner Gaylord was defeated.

“We also spent less than 5 percent of the total money spent on races in Raleigh, and we were able to frame the entire debate. Yes that is effective,” Debnam said.

Will the election results prevent Raleigh from becoming Drunk Town? I asked.

“It already is, on Fridays and Saturdays,” Debnam said. He later added, “A vision for Raleigh needs to be more than bars and nightclubs, and that is currently where things are heading downtown.”

It’s understandable that the initial impulse of some city officials would be to rebel against Raleigh’s portrayal as a wicked weekend vomitorium overrun by rambunctious rum-and-Cokers, but some people – OK, just I – think the city should embrace the designation as a destination for drunks. The city flag, which features an antlered deer on one side, could show that deer falling off a bar stool – or that fellow in the ad leaning against a lamp post about to hurl.

These shocking X-rays show teenagers and children as young as seven developing hunchbacks and abnormally curved spines because of an addiction to smartphones. 
A leading Australian chiropractor has warned that 'text neck' - a condition often brought on by bending over phones and tablets for several hours at a time - is becoming an epidemic.
Dr James Carter, based in Niagara Park, on the NSW Central Coast, said the relatively new condition can lead to anxiety and ­depression as well as spinal damage.
He revealed he had seen an 'alarming increase' in the number of patients with the condition over the past few years and said 50 per cent of them are school-age teenagers.


'Instead of a normal forward curve, patients can be seen to have a backwards curve. It can be degenerative, often causing head, neck, shoulder and back pain.
'Many patients come in complaining they have a headache, but we actually find text neck is the cause of it. They often fail a simple heel-to-toe test and tend to fall over.' 

Research suggests that smartphones users spent an average of four hours a day staring at their device - resulting in up to 1,400 hours a year of excess stresses on the cervical spine. 
The posture we adopt as we stare at our phones causes excessive wear and tear that may eventually require an operation to correct it.
Dr Carter, a former governor of the Australian Spinal Research Foundation, said the spine can shift by up to 4cm after repeated head tilts.
Still, he believes damage can be minimised for teenagers through regular exercise and a natural, 'healthy lifestyle'.
The condition can also result in emotional and behavioural changes as the stress can affect the release of 'happy hormones'.
'Resting your chin on your chest to look at your phone stretches the spinal cord and brain stem. This can affect respiration, heart rate and blood pressure.

'It can also mean that happy hormones, such as Endorphins and Serotonin are not released, meaning people can wake up anxious.' 
Dr Carter also advised avoiding using laptops or phones while sitting or lying in bed, raising monitors or devices to eye level and keeping your body moving. 
U.S. doctor Dr Kenneth Hansraj has also raised awareness about the condition and said the weight on the neck increases when we look down at our phones.
He said that although our heads weigh between 10lb and 12lb, the weight on the neck can increase to 27lbs at a 15-degree angle and 60lb at 60 degrees.
Sammy Margo, from the UK's Chartered Society of Physiotherapy, also believes that 'text neck' is on the rise. 
She said the condition can cause 'head pain, neck pain, arm pain and numbness'. 
'When you drop your chin on to your chest for a long period you are stretching the whole structure,' she said. 
'Eventually, in conjunction with a sedentary lifestyle, it could lead to serious consequences.' 

