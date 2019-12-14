require 'rails_helper'

RSpec.feature 'Task', type: :system do
  given(:project) { create :project }
  given(:task) { create :task, project_id: project.id }

  feature 'Task一覧' do
    given!(:task) { create :task, project_id: project.id }

    feature '正常系' do
      scenario '一覧ページにアクセスした場合、Taskが表示されること' do
        visit project_tasks_path(project)
        expect(page).to have_content task.title
        expect(Task.count).to eq 1
        expect(current_path).to eq project_tasks_path(project)
      end

      scenario 'Project詳細からTask一覧ページにアクセスした場合、Taskが表示されること' do
        visit project_path(project)
        click_link 'View Todos'

        work_in_new_tab
        expect(page).to have_content task.title
        expect(Task.count).to eq 1
        expect(current_path).to eq project_tasks_path(project)
      end
    end
  end

  feature 'Task新規作成' do
    feature '正常系' do
      scenario 'Taskが新規作成されること' do
        expected_size = Task.count + 1

        visit project_tasks_path(project)
        click_link 'New Task'
        fill_in 'task_title', with: 'test'
        click_button 'Create Task'
        expect(page).to have_content('Task was successfully created.')
        expect(Task.count).to eq expected_size
        expect(current_path).to eq "/projects/1/tasks/#{expected_size}"
      end
    end
  end

  feature 'Task詳細' do
    feature '正常系' do
      scenario 'Taskが表示されること' do
        visit project_task_path(project, task)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.status)
        expect(page).to have_content(task.deadline.strftime('%Y-%m-%d %H:%M'))
        expect(current_path).to eq project_task_path(project, task)
      end
    end
  end

  feature 'Task編集' do
    feature '正常系' do
      scenario 'Taskを編集した場合、一覧画面で編集後の内容が表示されること' do
        visit edit_project_task_path(project, task)
        deadline = Time.current
        fill_in 'Deadline', with: deadline
        click_button 'Update Task'
        click_link 'Back'
        expect(find('.task_list')).to have_content(deadline.strftime('%-m/%d %-H:%M'))
        expect(current_path).to eq project_tasks_path(project)
      end

      scenario 'ステータスを完了にした場合、Taskの完了日に今日の日付が登録されること' do
        visit edit_project_task_path(project, task)
        select 'done', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content('done')
        expect(page).to have_content(Time.current.strftime('%Y-%m-%d'))
        expect(current_path).to eq project_task_path(project, task)
      end

      feature '既にステータスが完了のタスクのステータスを変更した場合' do
        given(:task) { create(:task, :complete, project_id: project.id) }

        scenario 'Taskの完了日が更新されないこと' do
          visit edit_project_task_path(project, task)
          select 'todo', from: 'Status'
          click_button 'Update Task'
          expect(page).to have_content('todo')
          expect(page).not_to have_content(Time.current.strftime('%Y-%m-%d'))
          expect(current_path).to eq project_task_path(project, task)
        end
      end
    end
  end

  feature 'Task削除' do
    given!(:task) { create :task, project_id: project.id }

    feature '正常系' do
      scenario 'Taskが削除されること' do
        visit project_tasks_path(project)
        click_link 'Destroy'
        page.driver.browser.switch_to.alert.accept
        expect(find('.task_list')).not_to have_content task.title
        expect(Task.count).to eq 0
        expect(current_path).to eq project_tasks_path(project)
      end
    end
  end
end
