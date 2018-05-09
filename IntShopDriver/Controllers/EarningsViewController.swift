//
//  EarningsViewController.swift
//  IntShopDriver
//
//  Created by Olexandr on 10/28/17.
//  Copyright © 2017 Olexandr. All rights reserved.
//

import UIKit
import ScrollableGraphView

class EarningsViewController: UIViewController, SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate, ScrollableGraphViewDataSource {
    
    var months = ["OCT", "SEP", "AUG", "JUL", "JUN", "MAY"]
    var days = ["1", "30", "29", "28", "27", "26"]
    var weeklys = ["25 - 1", "20 - 25", "15 - 20", "10 - 15", "5 - 10", "1 - 5"]
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segment: SPSegmentedControl!
    var graphView: ScrollableGraphView!
    
    //MARK: GraphView initialize
    var graphConstraints = [NSLayoutConstraint]()
    var numberOfDataItems = 7
    var label = UILabel()
    
    lazy var darkLinePlotData: [Double] = self.generateRandomData(self.numberOfDataItems, max: 50, shouldIncludeOutliers: true)
    lazy var dotPlotData: [Double] =  self.generateRandomData(self.numberOfDataItems, variance: 4, from: 25)
    
    lazy var xAxisLabels: [String] =  [""]//self.generateSequentialLabels(self.numberOfDataItems, text: "FEB")
    
    //MARK: segment control
    private let borderColor: UIColor = UIColor.init(netHex: 0x263b50)
    private let backgroundColor: UIColor = UIColor.init(netHex: 0x233549)
    
    var weekly: Bool = false
    var daily: Bool = true
    var weeklyIndex = 0
    var dailyIndex = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "WeeklyCell", bundle: nil), forCellWithReuseIdentifier: "weekly")
        self.collectionView.register(UINib(nibName: "DailyCell", bundle: nil), forCellWithReuseIdentifier: "daily")
        self.collectionView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        // Segment Control
        self.segment.layer.borderColor = self.borderColor.cgColor
        self.segment.backgroundColor = self.backgroundColor
        self.segment.styleDelegate = self
        self.segment.delegate = self
        self.Initialize()
        
        // GraphView
        let rect = CGRect(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 200)
        self.graphView = createDarkGraph(rect)
        self.view.addSubview(self.graphView)
        self.setupConstraints()
        
        self.addLabel(withText: "Week Deliverys")
    }
    
    //MARK: Graph View Customize function
    
    // Creating GraphView
    // Reference lines are positioned absolutely. will appear at specified values on y axis
    fileprivate func createDarkGraph(_ frame: CGRect) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        
        // Setup the line plot.
        let linePlot = LinePlot(identifier: "darkLine")
        
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.colorFromHex(hexString: "#2d6d9d")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#223549")
        linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#223b51")
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.custom
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 3
        dotPlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#3493d5")
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.custom
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.positionType = .absolute
        // Reference lines will be shown at these values on the y-axis.
        referenceLines.absolutePositions = [10, 20, 25, 30]
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#233549")
        graphView.dataPointSpacing = self.view.frame.size.width/7
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        graphView.rangeMax = 30
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        
        return graphView
    }
    
    // Constraints and Helper Functions
    private func setupConstraints() {
        
        self.graphView.translatesAutoresizingMaskIntoConstraints = false
        graphConstraints.removeAll()
        
        let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 200/667, constant: 0.0)
        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -100)
        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
        
        graphConstraints.append(heightConstraint)
        graphConstraints.append(bottomConstraint)
        graphConstraints.append(leftConstraint)
        graphConstraints.append(rightConstraint)
        
        self.view.addConstraints(graphConstraints)
    }
    
    private func addLabel(withText text: String) {
        
        label.removeFromSuperview()
        label = createLabel(withText: text)
        label.isUserInteractionEnabled = false
        
        let leftConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.graphView, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -50)
        
        let topConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.graphView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -20)
        
        let heightConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: label.frame.width * 2.5)
        
        
        self.view.insertSubview(label, aboveSubview: graphView)
        self.view.addConstraints([leftConstraint, topConstraint, heightConstraint, widthConstraint])
    }
    
    private func createLabel(withText text: String) -> UILabel {
        let label = UILabel()
        
        label.backgroundColor = UIColor.clear
        
        label.text = text
        label.textColor = UIColor.init(netHex: 0x6f7883)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        
        return label
    }
    
    // Implementation for ScrollableGraphViewDataSource protocol
    
    /* You would usually only have a couple of cases here, one for each
       plot you want to display on the graph. However as this is showing
       off many graphs with different plots, we are using one big switch
       statement. */
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        
        switch(plot.identifier) {
            
        case "darkLine":
            return darkLinePlotData[pointIndex]
        case "darkLineDot":
            return darkLinePlotData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        // Ensure that you have a label to return for the index
        return ""//xAxisLabels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return numberOfDataItems
    }
    
    func reloadDidTap() {
        
        // TODO: Currently changing the number of data items is not supported.
        // It is only possible to change the the actual values of the data before reloading.
        // numberOfDataItems = 30
        
        // data for graphs with a single plot
        darkLinePlotData = self.generateRandomData(self.numberOfDataItems, max: 50, shouldIncludeOutliers: true)
        dotPlotData = self.generateRandomData(self.numberOfDataItems, variance: 4, from: 25)
        
        xAxisLabels = [""]
        
//        self.graphView.removeFromSuperview()
        
        // GraphView
        let rect = CGRect(x: 0, y: self.view.frame.size.height - 300, width: self.view.frame.size.width, height: 200)
        self.graphView = createDarkGraph(rect)
        self.view.addSubview(self.graphView)
        self.setupConstraints()
        
        self.addLabel(withText: "Week Deliverys")
    }
    
    // Data Generation
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateRandomData(_ numberOfItems: Int, variance: Double, from: Double) -> [Double] {
        
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            
            let randomVariance = Double(arc4random()).truncatingRemainder(dividingBy: variance)
            var randomNumber = from
            
            if(arc4random() % 100 < 50) {
                randomNumber += randomVariance
            }
            else {
                randomNumber -= randomVariance
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
    private func generateSequentialLabels(_ numberOfItems: Int, text: String) -> [String] {
        var labels = [String]()
        for i in 0 ..< numberOfItems {
            labels.append("\(text) \(i+1)")
        }
        return labels
    }
    
    // The type of the current graph we are showing.
    enum GraphType {
        case simple
        case multiOne
        case multiTwo
        case dark
        case bar
        case dot
        case pink
        
        mutating func next() {
            switch(self) {
            case .simple:
                self = GraphType.multiOne
            case .multiOne:
                self = GraphType.multiTwo
            case .multiTwo:
                self = GraphType.dark
            case .dark:
                self = GraphType.bar
            case .bar:
                self = GraphType.dot
            case .dot:
                self = GraphType.pink
            case .pink:
                self = GraphType.simple
            }
        }
    }

    
    //MARK: Segment Control customize
    func Initialize() {
        
        //MARK: segmentControl customize.
        //second segment control
        let yFirstCell = self.createCell(
            text: "Daily Earnings")
//            image: self.createImage(withName: "cloudy-day")
        
        yFirstCell.layout = .onlyText
        let ySecondCell = self.createCell(
            text: "Weekly Earnings")
//            image: self.createImage(withName: "cloudy")
        
        ySecondCell.layout = .onlyText
        self.segment.roundedRelativeFactor = 0.2
        self.segment.add(cells: [yFirstCell, ySecondCell])
        
    }
    
    //MARK: SegmentControl styleDelegate and delegate method.
    private func createCell(text: String) -> SPSegmentedControlCell {
        let cell = SPSegmentedControlCell.init()
        cell.label.text = text
        cell.label.font = UIFont(name: "Avenir-Medium", size: 13.0)!
        //cell.imageView.image = image
        return cell
    }
    
    private func createImage(withName name: String) -> UIImage {
        return UIImage.init(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    }
    
    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.black
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.white
        }, completion: nil)
        
        if index == 0 {
            self.daily = true
            self.weekly = false
            self.reloadDidTap()
            self.collectionView.reloadData()
        }else {
            self.daily = false
            self.weekly = true
            self.reloadDidTap()
            self.collectionView.reloadData()
        }
        
    }
    
    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
        SPAnimation.animate(0.1, animations: {
            segmentControlCell.imageView.tintColor = UIColor.white
        })
        
        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
            segmentControlCell.label.textColor = UIColor.init(netHex: 0x798490)
        }, completion: nil)
        
        
        
    }
    
    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
        let percentPosition = position / (segmentControl.frame.width - position) / CGFloat(segmentControl.cells.count - 1) * 100
        let intPercentPosition = Int(percentPosition)
//        self.percentIndicatorViewLabel.text = "scrolling: \(intPercentPosition)%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        if (collectionView?.numberOfItems(inSection: 0))! > 0  {
//            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
//            collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
//        }
//    }

}

extension EarningsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.reloadDidTap()
        
        if self.weekly {
            
            self.weeklyIndex = indexPath.row
        }else {
            self.dailyIndex = indexPath.row
        }
        
        self.collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.weekly {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weekly", for: indexPath) as! WeeklyCell
            
            cell.month.text = self.months[indexPath.row]
            if indexPath.row == self.weeklyIndex {
                cell.subView.backgroundColor = UIColor.init(netHex: 0x3493d5)
            }else {
               cell.subView.backgroundColor = UIColor.clear
            }
            
            cell.weekly.text = self.weeklys[indexPath.row]
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            
            return cell
            
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daily", for: indexPath) as! DailyCell
            
            if indexPath.row == self.dailyIndex {
                cell.subView.backgroundColor = UIColor.init(netHex: 0x3493d5)
            }else {
                cell.subView.backgroundColor = UIColor.clear
            }
            
            cell.day.text = self.days[indexPath.row]
            cell.month.text = self.months[indexPath.row]
            cell.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize.init()
        if self.weekly {
            cellSize = CGSize(width: 125, height: 80)
        }else {
            cellSize = CGSize(width: 80, height: 80)
        }
        
        
        return cellSize
    }
    
}
