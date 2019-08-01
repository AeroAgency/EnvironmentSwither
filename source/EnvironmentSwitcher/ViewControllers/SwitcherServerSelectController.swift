//
//  SwitcherServerSelectController.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 11/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

class SwitcherServerSelectController: UIViewController {
    
    @IBOutlet private var serverPicker: UIPickerView?
    
    weak var delegate: PickerServersDelegate?
    weak var dataSource: ServersDataSource? {
        didSet {
            serverPicker?.reloadAllComponents()
            selectCurrentServer()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        selectCurrentServer()
    }
    
    private func selectCurrentServer() {
        guard let source = dataSource,
            let index = source.serversList().firstIndex(of: source.current) else {
                return
        }
        self.serverPicker?.selectRow(index, inComponent: 0, animated: true)
    }
}

private extension SwitcherServerSelectController {
    @IBAction private func tapCancelButton() {
        delegate?.cancelSwitch()
    }
    
    @IBAction private func tapDoneButton() {
        guard let picker = serverPicker else {
            return
        }
        
        let selectedRow = picker.selectedRow(inComponent: 0)
        
        guard let serverDomain = pickerView(picker, titleForRow: selectedRow, forComponent: 0) else {
            return
        }
        
        delegate?.selectedServer(serverDomain)
    }
}

extension SwitcherServerSelectController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.serversList().count ?? 0
    }
    
}

extension SwitcherServerSelectController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let list = dataSource?.serversList() else {
            return "-"
        }
        
        return list[row]
        
    }
}
