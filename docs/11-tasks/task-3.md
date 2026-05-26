TASK ID: TASK-003
Description: بناء الـ Cron Job لجلب أسعار الذهب الخام من المصدر الخارجي وتحديث قاعدة البيانات.
Priority: High
Dependencies: TASK-001
Acceptance Criteria: تحديث البيانات في قاعدة البيانات تلقائياً كل ساعة.
Technical Notes: استخدم Laravel Scheduler و Laravel Jobs. تأكد من معالجة أخطاء الاتصال بالـ API الخارجي.
