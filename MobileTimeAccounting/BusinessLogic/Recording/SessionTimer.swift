/*
    Mobile Time Accounting
    Copyright (C) 2015

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import Foundation


protocol SessionTimerDelegate
{
    func didUpdateTimer(elapsedTime: String)
}


class SessionTimer: NSObject
{
    var timerTask: NSTimer!
    var delegate: SessionTimerDelegate!
    
    var startTime: NSDate!
    var stopTime: NSDate!
    var isPaused = false
    var isRunning = false
    
    
    /*
        Initializer for session timer object.
        Sets session timer delegate.
        
        @methodtype Constructor
        @pre Requires session timer delegate
        @post Delegate is set
    */
    init(delegate: SessionTimerDelegate)
    {
        self.delegate = delegate
    }
    
    
    /*
        Starts session timer by setting start time and starting internal timer task.
        
        @methodtype Command
        @pre Timer must be stopped and not paused
        @post Session timer started
    */
    func start()->NSDate
    {
        startTime = NSDate()
        isRunning = true
        isPaused = false
        timerTask = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("onTimerUpdate"), userInfo: nil, repeats: true)
        
        return startTime
    }
    
    
    /*
        Callback function, called when timer task is updated.
        Calculates elapsed time by using start time and current time and calls delegate function.
        
        @methodtype Command
        @pre -
        @post Calculate elapsed time and call delegate
    */
    func onTimerUpdate()
    {
        let currentTimeInSeconds = Int(NSDate().timeIntervalSince1970)
        let seconds = currentTimeInSeconds - Int(startTime.timeIntervalSince1970)
        delegate.didUpdateTimer(formatTimeToString(seconds))
    }
    
    
    /*
        Formats a given time interval in seconds to a string representation e.g. '128' -> '2 m 08 s'.
        
        @methodtype Convert
        @pre Time interval in seconds
        @post Converted string, representing the time
    */
    func formatTimeToString(elapsedTime : Int) -> String
    {
        var minutes = elapsedTime/60
        var seconds = elapsedTime%60
        
        return String(format: "%d:%0.2d", minutes, seconds)
    }
    
    
    /*
        Stops session timer by invalidating timer task and removing timer task object.
        
        @methodtype Command
        @pre Session timer needs to be in running state
        @post Stops session timer
    */
    func stop()->NSDate
    {
        stopTime = NSDate()
        isPaused = false
        invalidateTimer()
        
        return stopTime
    }
    
    
    /*
        Resumes timer task by creating new timer task and setting running true.
        
        @methodtype Command
        @pre Session timer needs to be in pause state
        @post Resumes timer task
    */
    func resume()
    {
        if isPaused
        {
            isPaused = false
            isRunning = true
            timerTask = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("onTimerUpdate"), userInfo: nil, repeats: true)
        }
    }
    
    
    /*
        Pauses session timer by invalidating timer task and removing timer task object.
        
        @methodtype Command
        @pre Timer must be in running state
        @post Pauses timer
    */
    func pause()
    {
        if isRunning
        {
            isPaused = true
            invalidateTimer()
        }
    }
    

    
    /*
        Invalidates timer task and set running to false.
        Also removes timer task object by setting value to nil.
        
        @methodtype Command
        @pre Timer must be running
        @post Invalidates timer task and sets timer task object ot nil
    */
    private func invalidateTimer()
    {
        isRunning = false
        if timerTask != nil
        {
            timerTask.invalidate()
            timerTask = nil
        }
    }
}