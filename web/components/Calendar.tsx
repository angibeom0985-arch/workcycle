import React from "react";
import { ShiftPattern } from "../types";

interface CalendarProps {
  currentDate: Date;
  setCurrentDate: (date: Date) => void;
  shiftPattern: ShiftPattern;
  onBackToSetup: () => void;
}

enum DayStatus {
  Off = "OFF",
  Day = "DAY",
  Night = "NIGHT",
  Future = "FUTURE",
}

const getShiftStatus = (
  date: Date,
  pattern: ShiftPattern
): DayStatus | null => {
  const { startDate: startDateString } = pattern;
  if (!startDateString) return null;

  const startDate = new Date(startDateString);
  // Adjust for timezone offset to prevent off-by-one day errors
  startDate.setMinutes(startDate.getMinutes() + startDate.getTimezoneOffset());

  if (date.getTime() < startDate.getTime()) {
    return DayStatus.Future;
  }

  const timeDiff = date.getTime() - startDate.getTime();
  const dayDiff = Math.floor(timeDiff / (1000 * 3600 * 24));

  const { dayShifts, nightShifts, offDays } = pattern;
  const cycleLength = dayShifts + nightShifts + offDays;
  if (cycleLength === 0) return null;

  const positionInCycle = dayDiff % cycleLength;

  if (positionInCycle < dayShifts) {
    return DayStatus.Day;
  } else if (positionInCycle < dayShifts + nightShifts) {
    return DayStatus.Night;
  } else {
    return DayStatus.Off;
  }
};

const Calendar: React.FC<CalendarProps> = ({
  currentDate,
  setCurrentDate,
  shiftPattern,
  onBackToSetup,
}) => {
  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();

  const firstDayOfMonth = new Date(year, month, 1);
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const startDayOfWeek = firstDayOfMonth.getDay();

  const prevMonth = () => setCurrentDate(new Date(year, month - 1, 1));
  const nextMonth = () => setCurrentDate(new Date(year, month + 1, 1));
  const goToToday = () => setCurrentDate(new Date());

  const today = new Date();
  const isToday = (day: number) =>
    year === today.getFullYear() &&
    month === today.getMonth() &&
    day === today.getDate();

  const renderDays = () => {
    const days = [];
    for (let i = 0; i < startDayOfWeek; i++) {
      days.push(
        <div
          key={`empty-${i}`}
          className="border-r border-b border-gray-200"
        ></div>
      );
    }

    for (let day = 1; day <= daysInMonth; day++) {
      const date = new Date(year, month, day);
      const status = getShiftStatus(date, shiftPattern);

      const dayOfWeek = date.getDay();
      const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;

      let bgColor = "bg-white";
      let textColor = "text-gray-700";
      let statusText = "";
      let statusColor = "";

      switch (status) {
        case DayStatus.Day:
          bgColor = "bg-yellow-100";
          statusText = "주간";
          statusColor = "text-yellow-700 font-semibold";
          break;
        case DayStatus.Night:
          bgColor = "bg-indigo-100";
          statusText = "야간";
          statusColor = "text-indigo-700 font-semibold";
          break;
        case DayStatus.Off:
          bgColor = "bg-red-100";
          statusText = "휴무";
          statusColor = "text-red-600";
          break;
      }

      if (isWeekend && status === null) {
        textColor = dayOfWeek === 0 ? "text-red-500" : "text-blue-500";
      }

      const dayCellClasses = `relative p-1 sm:p-2 border-r border-b border-gray-200 text-sm h-20 sm:h-24 md:h-28 transition-all duration-200 hover:bg-opacity-80 ${bgColor}`;

      days.push(
        <div key={day} className={dayCellClasses}>
          <div
            className={`relative z-10 flex justify-center items-center rounded-full w-7 h-7 sm:w-8 sm:h-8 ${
              isToday(day) ? "bg-blue-600 text-white font-bold shadow-md" : ""
            }`}
          >
            <span className={isToday(day) ? "" : textColor}>{day}</span>
          </div>
          {statusText && (
            <div
              className={`absolute inset-0 flex items-center justify-center text-2xl sm:text-3xl md:text-4xl font-bold ${statusColor} opacity-75`}
            >
              {statusText}
            </div>
          )}
        </div>
      );
    }

    return days;
  };

  const renderLegend = () => {
    const legendItems = [
      {
        label: "주간",
        color: "bg-yellow-100",
        borderColor: "border-yellow-200",
      },
      {
        label: "야간",
        color: "bg-indigo-100",
        borderColor: "border-indigo-200",
      },
      { label: "휴무", color: "bg-red-100", borderColor: "border-red-200" },
    ];

    return legendItems.map((item) => (
      <div key={item.label} className="flex items-center space-x-2">
        <div
          className={`w-4 h-4 rounded-full ${item.color} border ${item.borderColor}`}
        ></div>
        <span>{item.label}</span>
      </div>
    ));
  };

  const weekDays = ["일", "월", "화", "수", "목", "금", "토"];

  return (
    <div
      className="bg-white p-3 sm:p-5 mb-20 sm:mb-24 rounded-xl border border-gray-200"
      style={{ boxShadow: "0 2px 8px rgba(0,0,0,0.08)" }}
    >
      <div className="flex items-center justify-between mb-4 flex-wrap gap-2">
        <h2 className="text-lg sm:text-xl font-bold text-gray-900">
          {year}년 {month + 1}월
        </h2>
        <div className="flex items-center space-x-2">
          <button
            onClick={onBackToSetup}
            className="px-3 py-1.5 text-sm bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors font-medium"
          >
            설정 수정
          </button>
          <button
            onClick={goToToday}
            className="px-3 py-1.5 text-sm bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors font-medium"
          >
            오늘
          </button>
          <button
            onClick={prevMonth}
            className="p-2 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5 text-gray-700"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 19l-7-7 7-7"
              />
            </svg>
          </button>
          <button
            onClick={nextMonth}
            className="p-2 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="h-5 w-5 text-gray-700"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M9 5l7 7-7 7"
              />
            </svg>
          </button>
        </div>
      </div>
      <div className="grid grid-cols-7 border border-gray-200 rounded-lg overflow-hidden">
        {weekDays.map((day, index) => (
          <div
            key={day}
            className={`text-center py-2.5 font-semibold text-xs sm:text-sm border-r border-b border-gray-200 bg-gradient-to-b from-gray-50 to-gray-100 
            ${
              index === 0
                ? "text-red-600"
                : index === 6
                ? "text-blue-600"
                : "text-gray-700"
            }`}
          >
            {day}
          </div>
        ))}
        {renderDays()}
      </div>
      <div className="mt-4 pt-4 border-t border-gray-200 flex flex-wrap items-center justify-center sm:justify-end gap-x-4 gap-y-2 text-sm text-gray-600">
        {renderLegend()}
      </div>
    </div>
  );
};

export default Calendar;
