//
//  PlayerTableViewController.swift
//  PlayersApp
//
//  Created by Akhilesh Bhatia on 16/02/2019.
//  Copyright © 2019 Akhilesh Bhatia. All rights reserved.
//

import UIKit

class PlayerTableViewController: UITableViewController, XMLParserDelegate, UISearchResultsUpdating {
    
    var players : [PlayerInfo] = [];
    var filteredPlayers : [PlayerInfo] = [];
    var resultSearchController = UISearchController();
    
    let backgroundImage = UIImageView(image: UIImage(named: "bgImage 4"));

    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = "Top tennis players";
        backgroundImage.frame = self.tableView.frame;
        self.tableView.backgroundView = backgroundImage;
        
        //initialize parser, parse and get data after parsing
        let xmlParser = XMlPlayersParser();
        xmlParser.parsePlayerData();
        players = xmlParser.players;
                
        //initialize search bar controller
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil);
            controller.searchResultsUpdater = self;
            controller.obscuresBackgroundDuringPresentation = false;
            controller.searchBar.placeholder = "Search Player by Name";
            tableView.tableHeaderView = controller.searchBar;
            definesPresentationContext = true;
            
            return controller;
        })();
        
        //reload data after adding search bar
        tableView.reloadData();
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredPlayers.removeAll(keepingCapacity: false);
        //return all players whose name contain the text written in search bar
        filteredPlayers = players.filter{
            $0.name.lowercased().contains(searchController.searchBar.text!.lowercased());
        }
        self.tableView.reloadData();
    }
    
    func isFiltering() -> Bool {
        return resultSearchController.isActive && !resultSearchController.searchBar.text!.isEmpty;
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return filter data count if user is filtering
        if(isFiltering()){
            return filteredPlayers.count;
        }
        else{
            return players.count;
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlayerTableViewCell;
        cell.backgroundColor = UIColor(white: 1, alpha: 0.6);
        var playerInfo = PlayerInfo();
        //return filtering data from filteredPlayers array if user is filtering
        if(isFiltering()){
            playerInfo = filteredPlayers[indexPath.row];
        }
        else{
            playerInfo = players[indexPath.row];
        }
        cell.playerName!.text = playerInfo.name;
        cell.playerRank!.text = String(playerInfo.ranking);
        cell.playerImage!.image = UIImage(named: playerInfo.image);
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! PlayerBasicInfoViewController
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell);
        //set correct player data if user is filtering
        if(isFiltering()){
            destination.playerData = filteredPlayers[indexPath!.row];
        }
        else{
            destination.playerData = players[indexPath!.row];
        }
        
    }

}
