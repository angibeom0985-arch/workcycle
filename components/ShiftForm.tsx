import React from 'react';
import { ShiftPattern } from '../types';

interface ShiftFormProps {
  shiftPattern: ShiftPattern;
  setShiftPattern: React.Dispatch<React.SetStateAction<ShiftPattern>>;
}

const ShiftForm: React.FC<ShiftFormProps> = ({ shiftPattern, setShiftPattern }) => {
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value, type } = e.target;
    setShiftPattern(prev => ({
      ...prev,
      [name]: type === 'number' ? (parseInt(value, 10) || 0) : value,
    }));
  };

  return (
    <div className="bg-white p-4 sm:p-6 rounded-lg shadow-lg h-full">
      <h2 className="text-xl font-bold mb-4 text-gray-700">근무 패턴 설정</h2>
      
      <div className="space-y-4">
        <div>
          <label htmlFor="dayShifts" className="block text-sm font-medium text-gray-600 mb-1">
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
          <label htmlFor="nightShifts" className="block text-sm font-medium text-gray-600 mb-1">
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
          <label htmlFor="offDays" className="block text-sm font-medium text-gray-600 mb-1">
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
          <label htmlFor="startDate" className="block text-sm font-medium text-gray-600 mb-1">
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
      <div className="mt-6 p-4 bg-blue-50 border-l-4 border-blue-400 text-blue-700 rounded-r-lg">
        <h3 className="font-bold">사용법 안내</h3>
        <p className="text-sm mt-1">
          주간, 야간, 휴무 주기를 순서대로 입력하고, 주기가 시작되는 첫 주간 근무일을 선택하세요.
        </p>
      </div>
    </div>
  );
};

export default ShiftForm;