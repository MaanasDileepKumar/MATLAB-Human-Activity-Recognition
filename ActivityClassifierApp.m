classdef ActivityClassifierApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure          matlab.ui.Figure
        LoadDataButton    matlab.ui.control.Button
        ClassifyDataButton matlab.ui.control.Button
        UIAxes            matlab.ui.control.UIAxes
        StatusLabel       matlab.ui.control.Label
    end
    
    properties (Access = private)
        Data              table % Variable to store the data
        ActivityBreakdown double % Variable to store the activity breakdown
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: LoadDataButton
        function LoadDataButtonPushed(app, event)
            [file, path] = uigetfile('*.csv', 'Select an activity data file');
            if isequal(file, 0)
                app.StatusLabel.Text = 'Data loading cancelled.';
            else
                app.Data = readtable(fullfile(path, file));
                app.StatusLabel.Text = 'Data loaded successfully.';
            end
        end

        % Button pushed function: ClassifyDataButton
        function ClassifyDataButtonPushed(app, event)
            if isempty(app.Data)
                app.StatusLabel.Text = 'Please load data first.';
                return;
            end

            % Assuming 'Activity' is the column name in the CSV
            activityCounts = countcats(categorical(app.Data.Activity));
            app.ActivityBreakdown = activityCounts;

            % Update Pie Chart
            pie(app.UIAxes, app.ActivityBreakdown, 'LabelVerbosity', 'all');
            legend(app.UIAxes, categories(categorical(app.Data.Activity)), 'Location', 'bestoutside');
            app.StatusLabel.Text = 'Classification done.';
        end
    end

    % Component initialization
    methods (Access = private)
        
        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Activity Classifier App';

            % Create LoadDataButton
            app.LoadDataButton = uibutton(app.UIFigure, 'push');
            app.LoadDataButton.ButtonPushedFcn = createCallbackFcn(app, @LoadDataButtonPushed, true);
            app.LoadDataButton.Position = [26 423 100 22];
            app.LoadDataButton.Text = 'Load Data';

            % Create ClassifyDataButton
            app.ClassifyDataButton = uibutton(app.UIFigure, 'push');
            app.ClassifyDataButton.ButtonPushedFcn = createCallbackFcn(app, @ClassifyDataButtonPushed, true);
            app.ClassifyDataButton.Position = [136 423 100 22];
            app.ClassifyDataButton.Text = 'Classify Data';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Activity Breakdown');
            app.UIAxes.Position = [26 49 585 355];

            % Create StatusLabel
            app.StatusLabel = uilabel(app.UIFigure);
            app.StatusLabel.Position = [26 10 585 22];
            app.StatusLabel.Text = 'Load data to start classification.';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ActivityClassifierApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
