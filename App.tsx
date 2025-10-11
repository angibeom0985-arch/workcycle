import React, { useState } from "react";
import { ShiftPattern } from "./types";
import { useLocalStorage } from "./hooks/useLocalStorage";
import Header from "./components/Header";
import Ads from "./components/Ads";
import ShiftForm from "./components/ShiftForm";
import Calendar from "./components/Calendar";

type Page = "setup" | "calendar";

const App: React.FC = () => {
  const [currentPage, setCurrentPage] = useState<Page>("setup");
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
    setCurrentPage("calendar");
  };

  const handleBackToSetup = () => {
    setCurrentPage("setup");
  };

  return (
    <div className="min-h-screen text-gray-800 relative">
      <Header />
      <Ads />
      <main className="container mx-auto p-2 sm:p-4 max-w-screen-lg">
        {currentPage === "setup" ? (
          <ShiftForm
            shiftPattern={shiftPattern}
            setShiftPattern={setShiftPattern}
            onComplete={handleCompleteSetup}
          />
        ) : (
          <Calendar
            currentDate={currentDate}
            setCurrentDate={setCurrentDate}
            shiftPattern={shiftPattern}
            onBackToSetup={handleBackToSetup}
          />
        )}
      </main>
    </div>
  );
};

export default App;
