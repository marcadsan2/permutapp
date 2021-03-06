//
//  MyPermutasTableViewController.swift
//  permutapp
//
//  Created by Maria Jesus Cadenas Sanchez on 11/05/2020.
//  Copyright © 2020 DlgaETSII. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class MyPermutasTableViewController: UITableViewController {
    var db: Firestore!
    
    
    var permutaArray = [Permuta]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        getPermutasForUser()
    }

    func getPermutasForUser(){
        let user = Auth.auth().currentUser?.uid
        db.collection("permutas").whereField("user", isEqualTo: user).getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                self.permutaArray = querySnapshot!.documents.compactMap({Permuta(dictionary: $0.data())})
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return permutaArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "permuta", for: indexPath)
        let permuta = permutaArray[indexPath.row]
        cell.textLabel?.text = "\(permuta.grade) Curso: \(permuta.course)"
        cell.detailTextLabel?.text = "Grupo origen: \(permuta.groupOrigin) Grupo destino: \(permuta.groupDestine)"
         return cell
    }

    
}
