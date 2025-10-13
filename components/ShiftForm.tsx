ㅍimport React from "react";
import { ShiftPattern } from "../types";

interface ShiftFormProps {
  shiftPattern: ShiftPattern;
  setShiftPattern: React.Dispatch<React.SetStateAction<ShiftPattern>>;
  onComplete: () => void;
}

const ShiftForm: React.FC<ShiftFormProps> = ({
  shiftPattern,
  setShiftPattern,
  onComplete,
}) => {
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type } = e.target;
    setShiftPattern((prev) => ({
      ...prev,
      [name]: type === "number" ? parseInt(value, 10) || 0 : value,
    }));
  };

  return (
    <div
      className="bg-white p-4 sm:p-6 pb-24 sm:pb-28 rounded-xl border border-gray-200 h-full"
      style={{ boxShadow: "0 2px 8px rgba(0,0,0,0.08)" }}
    >
      <h2 className="text-lg font-bold mb-4 text-gray-800 flex items-center">
        <span className="w-1 h-5 bg-blue-500 rounded-full mr-2"></span>
        근무 패턴 설정
      </h2>

      <div className="space-y-4">
        <div>
          <label
            htmlFor="dayShifts"
            className="block text-sm font-medium text-gray-600 mb-1"
          >
            주간 근무일
          </label>
          <input
            type="number"
            id="dayShifts"
            name="dayShifts"
            value={shiftPattern.dayShifts}
            onChange={handleInputChange}
            min="0"
            className="w-full px-4 py-2 bg-gray-100 border border-gray-200 rounded-md focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition"
          />
        </div>
        <div>
          <label
            htmlFor="nightShifts"
            className="block text-sm font-medium text-gray-600 mb-1"
          >
            야간 근무일
          </label>
          <input
            type="number"
            id="nightShifts"
            name="nightShifts"
            value={shiftPattern.nightShifts}
            onChange={handleInputChange}
            min="0"
            className="w-full px-4 py-2 bg-gray-100 border border-gray-200 rounded-md focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition"
          />
        </div>
        <div>
          <label
            htmlFor="offDays"
            className="block text-sm font-medium text-gray-600 mb-1"
          >
            연속 휴무일
          </label>
          <input
            type="number"
            id="offDays"
            name="offDays"
            value={shiftPattern.offDays}
            onChange={handleInputChange}
            min="1"
            className="w-full px-4 py-2 bg-gray-100 border border-gray-200 rounded-md focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition"
          />
        </div>
        <div>
          <label
            htmlFor="startDate"
            className="block text-sm font-medium text-gray-600 mb-1"
          >
            패턴 시작일
          </label>
          <input
            type="date"
            id="startDate"
            name="startDate"
            value={shiftPattern.startDate}
            onChange={handleInputChange}
            className="w-full px-4 py-2 bg-gray-100 border border-gray-200 rounded-md focus:ring-blue-500 focus:border-blue-500 focus:bg-white transition"
          />
        </div>
      </div>
      <div className="mt-6 p-4 bg-blue-50 border border-blue-200 text-blue-800 rounded-lg">
        <div className="flex items-start space-x-2">
          <svg
            className="w-5 h-5 text-blue-500 mt-0.5 flex-shrink-0"
            fill="currentColor"
            viewBox="0 0 20 20"
          >
            <path
              fillRule="evenodd"
              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z"
              clipRule="evenodd"
            />
          </svg>
          <div>
            <h3 className="font-semibold text-sm">사용법</h3>
            <p className="text-sm mt-1 leading-relaxed">
              주간, 야간, 휴무 주기를 입력하고 패턴 시작일을 선택하세요.
            </p>
          </div>
        </div>
      </div>

      <button
        onClick={onComplete}
        className="mt-6 mb-20 sm:mb-24 w-full py-3 bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg transition-colors shadow-md hover:shadow-lg"
      >
        완료
      </button>
    </div>
  );
};

export default ShiftForm;
