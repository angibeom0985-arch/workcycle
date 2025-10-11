import React, { useState } from 'react';
import { ShiftPattern } from './types';
import { useLocalStorage } from './hooks/useLocalStorage';
import Header from './components/Header';
import ShiftForm from './components/ShiftForm';
import Calendar from './components/Calendar';

const App: React.FC = () => {
  const [currentDate, setCurrentDate] = useState(new Date());
  
  const [shiftPattern, setShiftPattern] = useLocalStorage<ShiftPattern>('shiftPattern', {
    dayShifts: 2,
    nightShifts: 2,
    offDays: 4,
    startDate: new Date().toISOString().split('T')[0],
  });

  return (
    <div className="min-h-screen text-gray-800">
      <Header />
      <main className="container mx-auto p-2 sm:p-4">
        <div className="flex flex-col gap-4">
          <div>
            <ShiftForm
              shiftPattern={shiftPattern}
              setShiftPattern={setShiftPattern}
            />
          </div>
          <div>
            <Calendar
              currentDate={currentDate}
              setCurrentDate={setCurrentDate}
              shiftPattern={shiftPattern}
            />
          </div>
        </div>
      </main>
    </div>
  );
};

export default App;