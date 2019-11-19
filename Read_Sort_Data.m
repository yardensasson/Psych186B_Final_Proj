[~,~,batting_info]=xlsread('Batting.xls');
batting_info(1,:)=[];
[~,~,HOF_names]=xlsread('HallOfFame.xls');
HOF_names(1,:)=[];
[~,~, All_Star_List]=xlsread('AllstarFull.xls');
All_Star_List(1,:)=[];
[~,~,Awards_list]=xlsread('AwardsPlayers.xls');
Awards_list(1,:)=[];
[~,~,postseason_batting]=xlsread('BattingPost.xls');
postseason_batting(1,:)=[];

HOF_size=size(HOF_names,1);


HOF_total_ballots=HOF_names(:,4);
HOF_ballots_needed=HOF_names(:,5);
HOF_ballot_votes=HOF_names(:,6);
HOF_induction=HOF_names(:,7);

award_id=Awards_list(:,2);
year_of_award=Awards_list(:,3);
league_award_id=Awards_list(:,4);
cmpstr=[];
for i=1:size(HOF_names,1)
    cmpstr(i) = strcmp('Player',HOF_names(i,8));
    if cmpstr(i) == 1
        for col_fill=1:9
        HOF_players(i,col_fill)= HOF_names(i,col_fill);
        end
    else
        HOF_players(i,col_fill)= [];
    end
end

