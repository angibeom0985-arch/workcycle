import React from 'react';

const Header: React.FC = () => {
  return (
    <header className="bg-white border-b border-gray-200" style={{ boxShadow: '0 1px 3px rgba(0,0,0,0.05)' }}>
      <div className="container mx-auto px-4 py-4 sm:py-5 lg:px-8">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <div>
              <h1 className="text-xl sm:text-2xl font-bold text-gray-900">
                교대근무 달력
              </h1>
              <p className="text-xs sm:text-sm text-gray-500 hidden sm:block">
                간편한 근무 스케줄 관리
              </p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;