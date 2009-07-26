function update_status_list(broadcast_uid, since_id){
    var url = "http://search.twitter.com/search.json?q=camtweet.com%2Fs%2F" + broadcast_uid + "&callback=handle_status_list";
    if(since_id){
        url += "&since_id=" + since_id;
    }
    var tag = document.createElement('script');
    tag.src = url;
    document.body.appendChild(tag);
}

function handle_status_list(results){
    var statuses = results["results"];
    rendered_up_to_id = results['max_id'];
    add_statuses(statuses);
}

function add_statuses(statuses){
    // iterate backwards so that the most recent stuff winds up on the bottom
    for(var i=statuses.length - 1; i>=0; i--){
        var status = statuses[i];
        if($('status_' + status.id) == null){
            $('status_list').insertBefore(format_status(status), status_list.firstChild);
        }
    }
    while($('status_list').childNodes.length > 7){
        $('status_list').removeChild($('status_list').firstChild);
    }
}

function time_ago_in_words(from) {
    return distance_of_time_in_words(new Date().getTime(), from) 
}

function distance_of_time_in_words(to, from) {
    seconds_ago = ((to  - from) / 1000);
    minutes_ago = Math.floor(seconds_ago / 60)

    if(seconds_ago < 0){
        seconds_ago = 0;
    }

    if(minutes_ago < 0){
        minutes_ago = 0;
    }

    if(minutes_ago == 0) { return "less than a minute";}
    if(minutes_ago == 1) { return "a minute";}
    if(minutes_ago < 45) { return minutes_ago + " minutes";}
    if(minutes_ago < 90) { return " about 1 hour";}
    hours_ago  = Math.round(minutes_ago / 60);
    if(minutes_ago < 1440) { return "about " + hours_ago + " hours";}
    if(minutes_ago < 2880) { return "1 day";}
    days_ago  = Math.round(minutes_ago / 1440);
    if(minutes_ago < 43200) { return days_ago + " days";}
    if(minutes_ago < 86400) { return "about 1 month";}
    months_ago  = Math.round(minutes_ago / 43200);
    if(minutes_ago < 525960) { return months_ago + " months";}
    if(minutes_ago < 1051920) { return "about 1 year";}
    years_ago  = Math.round(minutes_ago / 525960);
    return "over " + years_ago + " years" 
}


function format_status(status){
    var container = document.createElement('div');
    container.className = "status";
    container.id = "status_" + status.id;
    
    var user_img_link = document.createElement("a");
    user_img_link.href = "http://www.twitter.com/" + status.from_user;
    
    var img = document.createElement('img');
    img.src = status.profile_image_url;
    img.width = 48;
    img.height = 48;
    
    user_img_link.appendChild(img);

    var text_container = document.createElement('div');
    text_container.className = 'text';

    var user_link = document.createElement('a');
    user_link.href = "http://www.twitter.com/" + status.from_user;
    user_link.innerHTML = status.from_user;
    
    var display_text = document.createElement('p');
    display_text.className = "body";
    display_text.innerHTML = status.text.replace(/^@\w+/, "").replace(/http:\/\/camtweet.com\/s\/\w+/, "");

    var meta_data = document.createElement('p');
    meta_data.className = 'meta small';
    meta_data.innerHTML = time_ago_in_words(new Date(status.created_at)) + " from " + status.source.unescapeHTML();

    text_container.appendChild(user_link);
    text_container.appendChild(display_text);
    text_container.appendChild(meta_data);

    container.appendChild(user_img_link);
    container.appendChild(text_container);
    return container;
}