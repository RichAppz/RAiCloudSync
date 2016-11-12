# RAiCloudSync

##What is the purpose?

This is a clean and useful solution to storing `NSUserDefaults` in iCloud, adding keys to the manager will set up a listener for both directions and let you know if there have been any changes.

##Instructions

1. Download and drag the RAiCloudSync to your project
2. Add to start `RAiCloudSync.start(withKeys: ["key1", "key2", "key3"])`
3. Use `NSUserDefaults` as normal

To listen for changes in the sync use `RAiCloudSyncNotification`, eg:

	NotificationCenter.default.addObserver(
		self,
		selector: <method to call>,
		name: RAiCloudSyncNotification,
		object: nil
	)

####Start

	RAiCloudSync.start(withKeys: ["key1", "key2", "key3"])

####Adding an additional key

	RAiCloudSync.add(key: "key2")

####Remove a key

	RAiCloudSync.remove(key: "key2")

####Stop

	RAiCloudSync.stop()


###Legal bit

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


PayPal Donations to: [rich@richappz.com](<mailto:rich@richappz.com>)
