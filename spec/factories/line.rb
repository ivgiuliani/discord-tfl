# frozen_string_literal: true

FactoryGirl.define do
  factory :line, class: Tfl::Line do
    id :central
    display_name "Central"
    mode "tube"
    current_status "Good Service"
    disruptions []

    initialize_with do
      new(id: id,
          display_name: display_name,
          mode: mode,
          current_status: current_status,
          disruptions: disruptions)
    end

    trait :central do
      id :central
      display_name "Central"
    end

    trait :circle do
      id :circle
      display_name "Circle"
    end

    trait :northern do
      id :northern
      display_name "Northern"
    end

    trait :good_service do
      current_status "Good Service"
      disruptions []
    end

    trait :planned_closure do
      current_status "Planned Closure"
      disruptions ["Saturday 8 and Sunday 9 October, no service throughout the line."]
    end

    trait :part_closure do
      current_status "Part Closure"
      disruptions ["Saturday 8 and Sunday 9 October, " \
        "no service between Embankment and Dagenham East. Replacement buses operate"]
    end

    trait :service_closed do
      current_status "Service Closed"
      disruptions ["Train service resumes Monday Morning at 0615"]
    end

    trait :special_service do
      current_status "Special Service"
      disruptions ["Buses in the Canada Water, Limehouse, London Bridge, Southwark, " \
        "Tower Hill and Waterloo areas delayed up to forty minutes and some services " \
        "may terminate early due to the planned closure of Tower Bridge. Allow extra " \
        "time for your journey and follow @TfLBusAlerts on Twitter for " \
        "realtime information."]
    end
  end
end