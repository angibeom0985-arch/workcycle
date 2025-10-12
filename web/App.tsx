import React, { useState } from "react";
import { Routes, Route, useNavigate } from "react-router-dom";
import { ShiftPattern } from "./types";
import { useLocalStorage } from "./hooks/useLocalStorage";
import Header from "./components/Header";
import Ads from "./components/Ads";
import ShiftForm from "./components/ShiftForm";
import Calendar from "./components/Calendar";

const App: React.FC = () => {
  const navigate = useNavigate();
  const [currentDate, setCurrentDate] = useState(new Date());

  const [shiftPattern, setShiftPattern] = useLocalStorage<ShiftPattern>(
    "shiftPattern",
    {
      dayShifts: 2,
      nightShifts: 2,
      offDays: 4,
      startDate: new Date().toISOString().split("T")[0],
    }
  );

  const handleCompleteSetup = () => {
    navigate("/calendar");
  };

  const handleBackToSetup = () => {
    navigate("/");
  };

  return (
    <div className="min-h-screen text-gray-800 relative pb-24 sm:pb-32 md:pb-36">
      <Header />
      <Ads />
      <main className="container mx-auto p-2 sm:p-4 max-w-screen-lg">
        <Routes>
          <Route
            path="/"
            element={
              <ShiftForm
                shiftPattern={shiftPattern}
                setShiftPattern={setShiftPattern}
                onComplete={handleCompleteSetup}
              />
            }
          />
          <Route
            path="/calendar"
            element={
              <Calendar
                currentDate={currentDate}
                setCurrentDate={setCurrentDate}
                shiftPattern={shiftPattern}
                onBackToSetup={handleBackToSetup}
              />
            }
          />
        </Routes>
      </main>
    </div>
  );
};

export default App;
