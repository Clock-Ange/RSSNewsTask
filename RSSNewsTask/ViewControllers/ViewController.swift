//
//  ViewController.swift
//  RSSNewsTask
//
//  Created by Геннадий Махмудов on 02.11.2020.
//

import UIKit

class ViewController: UITableViewController {
    
    private var dataManager = DataManager()
    private var selectedNews = Set<String>()
    
    private var dummy: UITextField?
    private let picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUpdateDelegate()
        configureTitle()
        configureTableView()
        configureTableViewConstraints()
        configureRefreshControl()
        configureRightBarButton()
        configurePickerView()
        configureDummy()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func configureTitle(){
        title = "RSS Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func configureRefreshControl(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        dataManager.chooseNewSource(from: dataManager.getCurrentURL())
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureRightBarButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleTap))
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    @objc func handleTap(){
        let ac = UIAlertController(title: "Current RSS Source is \(dataManager.getCurrentURL())", message: "Do you want to add new one?", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] (_) in
            if let text = ac.textFields?[0].text {
                if text != "" {
                    self?.dataManager.chooseNewSource(from: text)
                }
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Select from previous sources", style: .default, handler: { [weak self] (_) in
            self?.dummy?.becomeFirstResponder()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}

extension ViewController: UpdateDelegate {
    
    func didUpdate(sender: DataManager) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func configureUpdateDelegate(){
        dataManager.setUpdateDelegate(delegate: self)
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataManager.selectFromPrevious().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataManager.selectFromPrevious()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let previous = dataManager.selectFromPrevious()[row]
        if previous != dataManager.getCurrentURL() {
            dataManager.chooseNewSource(from: previous)
        }
        dummy?.resignFirstResponder()
    }
    
    private func configurePickerView(){
        picker.delegate = self
        picker.dataSource = self
    }
    
    private func configureDummy(){
        dummy = UITextField(frame: CGRect.zero)
        view.addSubview(dummy ?? UITextField())
        dummy?.inputView = picker
    }
    
    
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.numberOfItems()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomViewCell else {
            return UITableViewCell()
        }
        let item = dataManager.getItems()[indexPath.row]
        cell.titleLabel.text = item.title ?? ""
        cell.detailLabel.text = "\(item.pubDate ?? Date())"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let item = dataManager.getItems()[indexPath.row]
        if !selectedNews.contains(item.title ?? ""){
            selectedNews.insert(item.title ?? "")
        }
        vc.setNewsSetter(with: NewsSetter(item: item))
        navigationController?.pushViewController(vc, animated: true)
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = dataManager.getItems()[indexPath.row]
        if  selectedNews.contains(item.title ?? ""){
            cell.backgroundColor = .gray
        } else {
            cell.backgroundColor = .none
        }
    }

    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func configureTableViewConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}



