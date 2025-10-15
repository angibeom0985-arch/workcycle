import React from 'react';

const PrivacyPolicy: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 py-8 px-4">
      <div className="max-w-4xl mx-auto bg-white rounded-lg shadow-md p-8">
        <h1 className="text-3xl font-bold mb-6 text-gray-900">개인정보 처리방침</h1>
        
        <div className="space-y-6 text-gray-700">
          <section>
            <p className="text-sm text-gray-600 mb-4">최종 수정일: 2025년 10월 15일</p>
            <p className="mb-4">
              교대근무 달력("본 앱")은 사용자의 개인정보를 중요하게 생각하며, 
              「개인정보 보호법」 및 관련 법령을 준수하고 있습니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">1. 개인정보의 수집 및 이용</h2>
            <div className="space-y-2">
              <p>본 앱은 다음과 같은 방식으로 개인정보를 처리합니다:</p>
              <ul className="list-disc list-inside space-y-2 ml-4">
                <li><strong>수집하는 정보:</strong> 본 앱은 사용자의 개인정보를 수집하지 않습니다.</li>
                <li><strong>저장 위치:</strong> 모든 근무 스케줄 데이터는 사용자의 기기에만 로컬로 저장됩니다.</li>
                <li><strong>외부 전송:</strong> 어떠한 데이터도 외부 서버로 전송되지 않습니다.</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">2. 개인정보의 보유 및 이용 기간</h2>
            <p>
              사용자가 앱을 삭제하거나 앱 내에서 데이터를 삭제하는 즉시 모든 데이터가 영구적으로 삭제됩니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">3. 개인정보의 제3자 제공</h2>
            <p>
              본 앱은 사용자의 개인정보를 제3자에게 제공하지 않습니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">4. 개인정보 처리의 위탁</h2>
            <p>
              본 앱은 개인정보 처리를 외부에 위탁하지 않습니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">5. 이용자의 권리</h2>
            <p>
              사용자는 언제든지 앱 내에서 자신의 데이터를 조회하거나 삭제할 수 있습니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">6. 개인정보의 안전성 확보 조치</h2>
            <p>
              본 앱은 모든 데이터를 사용자 기기에 암호화하여 저장하며, 
              외부로 전송하지 않음으로써 개인정보의 안전성을 확보하고 있습니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">7. 개인정보 보호책임자</h2>
            <div className="space-y-2">
              <p>개인정보 보호와 관련된 문의사항이 있으신 경우 아래로 연락 주시기 바랍니다:</p>
              <ul className="list-none space-y-1 ml-4">
                <li>이메일: [이메일 주소를 입력하세요]</li>
              </ul>
            </div>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">8. 개인정보 처리방침의 변경</h2>
            <p>
              본 개인정보 처리방침은 법령, 정책 또는 보안기술의 변경에 따라 내용의 추가, 삭제 및 수정이 있을 시에는 
              변경사항을 앱 내 공지사항 또는 웹사이트를 통해 고지할 것입니다.
            </p>
          </section>

          <section>
            <h2 className="text-2xl font-semibold mb-3 text-gray-900">9. 광고 서비스</h2>
            <p>
              본 앱은 Google AdSense를 통해 광고를 표시할 수 있습니다. 
              Google AdSense는 쿠키를 사용하여 사용자의 관심사에 맞는 광고를 제공할 수 있으며, 
              사용자는 <a href="https://www.google.com/settings/ads" target="_blank" rel="noopener noreferrer" 
              className="text-blue-600 hover:underline">Google 광고 설정</a>에서 
              맞춤 광고를 선택 해제할 수 있습니다.
            </p>
          </section>

          <section className="mt-8 pt-6 border-t border-gray-200">
            <p className="text-sm text-gray-600">
              본 개인정보 처리방침은 2025년 10월 15일부터 적용됩니다.
            </p>
          </section>
        </div>

        <div className="mt-8 text-center">
          <a href="/" className="text-blue-600 hover:text-blue-800 hover:underline">
            앱으로 돌아가기
          </a>
        </div>
      </div>
    </div>
  );
};

export default PrivacyPolicy;
