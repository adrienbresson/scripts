<?php

//Author: Adrien
//Date : 20130709
//Get .torrent file from nyaa.eu

$download_dir = '/home/transmission/downloads/.watchdir';
$max_range = 20;
$json_file = '/tmp/auto_download_nyaa.json';
$animes['onepiece'] = [ 
     'rss'                  => 'http://www.nyaa.eu/?page=rss&term=one+piece&sort=2', //sorted by seeders
     'regex'                => '/(?P<title>one.*piece.*[0-9]+.*720p)/i',
     'last_watched_episode' => 600,  //default value, will be overwrited if anime found in .json file
     'max_range'            => $max_range,
];
$animes['narutoshippuuden'] = [ 
     'rss'                  => 'http://www.nyaa.eu/?page=rss&term=naruto+shippuuden+&sort=2',
     'regex'                => '/(?P<title>naruto.*shippuuden.*[0-9]+.*720p)/i',
     'last_watched_episode' => 310,
     'max_range'            => $max_range,
];

$retrived_json = get_lasts_downloaded_torrents_from_file($json_file);
if($retrived_json != false) {
    foreach($animes as $anime => $datas) {
        $max = max(array_keys($retrived_json[$anime]));
        if(is_numeric($max)) {
            $animes[$anime]['last_watched_episode'] = $max;
        }
    }
}

foreach($animes as $anime => $datas) {
    $queued_episodes[$anime] = get_anime_list($anime, $datas);
}
//var_dump($queued_episodes); 
download_torrents($queued_episodes, $download_dir);
write_downloaded_torrents_to_file($queued_episodes, $json_file);

function simple_curl($_feed){
    $_ch_xml = curl_init();
    curl_setopt($_ch_xml, CURLOPT_URL, $_feed); 
    curl_setopt($_ch_xml, CURLOPT_RETURNTRANSFER, True); 
    return curl_exec($_ch_xml); 
}

function get_anime_list($_anime, $_datas) {
    $_rss = $_datas['rss'];
    $_regex = $_datas['regex'];
    $_last_watched_episode = $_datas['last_watched_episode'];
    $_max_range = $_datas['max_range'];

    $_queued_episodes[$_anime] = array();
    
    $_content = simple_curl($_rss); 
    $_xml = simplexml_load_string($_content);   //var_dump($_xml->channel->item);
 
    foreach($_xml->channel->item as $_torrent){
        $_title = (string) $_torrent->title;
        $_match_title = preg_match($_regex, $_title, $_matches);
        if(preg_match($_regex, $_torrent->title) == 1){
            $_match_episode = preg_match('/(?<number>[0-9]{'. strlen($_last_watched_episode) .',})/',$_matches['title'],$_episode);
            $_number = (int)$_episode['number'];
            if($_number > $_last_watched_episode && $_number < $_last_watched_episode + $_max_range && !array_key_exists($_number, $_queued_episodes[$_anime])){
                //echo (string)$_torrent->title . ' [' . (string)$_torrent->link . '] ' . '(' . $_number . ')' . PHP_EOL;
                $_queued_episodes[$_anime][$_number] = [
                     'title' => (string)$_torrent->title, 
                     'link'  => (string)$_torrent->link, 
                ];
            }
        }
    }
    ksort($_queued_episodes[$_anime]);
    return $_queued_episodes[$_anime];
}

function download_torrents($_queued_episodes, $_download_dir) {
    foreach($_queued_episodes as $_anime => $_anime_datas ) {
        foreach($_anime_datas as $_episode_number => $_episode_datas) {
            $_file_to_write = $_download_dir . '/' . $_anime . '_' . $_episode_number . '.torrent';
            echo 'Adding ' . $_file_to_write . ' ['. $_episode_datas['link'] .']' . PHP_EOL;
            file_put_contents($_file_to_write, fopen($_episode_datas['link'], 'r'));
        }
    }
}

function write_downloaded_torrents_to_file($_queued_episodes, $_json_file) {
    file_put_contents($_json_file, json_encode($_queued_episodes));
}

function get_lasts_downloaded_torrents_from_file($_json_file) {
    if(file_exists($_json_file)) {
        return json_decode(file_get_contents($_json_file), true);
    }
    return false; 
}

echo "END" . PHP_EOL;
?>