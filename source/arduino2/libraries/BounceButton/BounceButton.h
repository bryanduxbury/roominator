#ifndef BounceButton_h
#define BounceButton_h

class BounceButton {
	public:
		BounceButton(int pin_number);
		void initialize();
		int getState();
		int getLastState();
		int getTime();
		bool check();
		
	private:
		int pin;
		int currentState;
		int lastState;
		int lastSavedState;
		long lastDebounceTime;
};

#endif